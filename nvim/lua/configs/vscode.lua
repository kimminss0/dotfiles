if not vim.g.vscode then
  return
end

vim.opt.foldopen:remove('hor')

local vscode = require('vscode')
local scrollHalfPage = function(to)
  vscode.eval(string.format([[

class EditorViewportState {
  #textEditor;
  #visibleRanges;
  #lineCount;
  #outdated;

  constructor(textEditor) {
    this.#textEditor = textEditor;
    this.#outdated = false;
    this.#visibleRanges = this.#textEditor.visibleRanges.slice();
    this.#lineCount = this.#textEditor.document.lineCount;
    this.cursorPosition = this.#textEditor.selection.active;
    this.cursorOffset = this.offsetFromPosition(this.cursorPosition);
    this.viewportStart = this.#visibleRanges[0]?.start ?? null;
    this.viewportEnd = this.#visibleRanges.at(-1)?.end ?? null;
    if (this.viewportStart !== null) {
      this.isDocumentStartVisible = this.viewportStart.line === 0;
    } else {
      this.isDocumentStartVisible = true;
    }
    if (this.viewportEnd !== null) {
      this.viewportHeightApprox = this.offsetFromPosition(this.viewportEnd) + 1;
      this.viewportHeightApproxHalf = Math.floor(this.viewportHeightApprox / 2);
      this.isDocumentEndVisible = this.viewportEnd.line === this.#lineCount - 1;
    } else {
      this.viewportHeightApprox = 0;
      this.viewportHeightApproxHalf = 0;
      this.isDocumentEndVisible = true;
    }
  }

  static capture() {
    const activeEditor = vscode.window.activeTextEditor;
    if (!activeEditor) {
      throw new Error("No active editor found.");
    }
    return new EditorViewportState(activeEditor);
  }

  offsetFromPosition(position) {
    const ranges = this.#visibleRanges.slice();
    if (ranges.every((range) => !range.contains(position))) {
      return -1;
    }

    // Remove ranges that occur after given position
    const excludeAfter = ranges.findIndex((range) => range.start.line > position.line);
    if (excludeAfter !== -1) {
      ranges.splice(excludeAfter);
    }

    // Update the end position of the last range to the cursor position.
    if (ranges.length > 0) {
      const lastRange = ranges[ranges.length - 1];
      ranges[ranges.length - 1] = lastRange.with({ end: position });
    }

    // Sum of the number of lines for each range
    return ranges
      .map((range) => range.end.line - range.start.line + 1)
      .reduce((acc, cur) => acc + cur, -1);
  }

  // Calculate the position based on the offset from the viewport top.
  positionFromOffset(offset) {
    let acc = 0;
    for (const range of this.#visibleRanges) {
      const rangeLines = range.end.line - range.start.line + 1;
      if (acc + rangeLines > offset) {
        return range.start.with({
          line: range.start.line + (offset - acc)
        });
      }
      acc += rangeLines;
    }
    return null;
  }

  async scroll(direction) {
    if (this.#outdated) {
      throw "Attempt to use an outdated capture"
    }
    this.#outdated = true;

    const scrollHalfPage = async (direction) =>
      vscode.commands.executeCommand('editorScroll', {
        to: direction,
        by: 'halfPage',
        revealCursor: false
      });

    const scrollLines = async (direction, linesToScroll) =>
      vscode.commands.executeCommand('editorScroll', {
        to: direction,
        by: 'line',
        value: linesToScroll,
        revealCursor: false
      });

    let updatedCapture;
    if (direction === 'up') {
      await scrollHalfPage(direction);
      updatedCapture = EditorViewportState.capture();
    } else if (direction === 'down') {
      // Do not scroll down if the end of the document is reached.
      if (this.isDocumentEndVisible) {
        this.#outdated = false;
        return this;
      }

      // Scroll down by half a page, attempting to prevent over-scrolling.
      const viewportBottomMargin = this.#lineCount - (this.viewportEnd.line + 1);
      if (viewportBottomMargin < this.viewportHeightApproxHalf - 1) {
        const linesToScroll = viewportBottomMargin + 1;
        await scrollLines(direction, linesToScroll);
      } else {
        await scrollHalfPage(direction);
      }
      updatedCapture = EditorViewportState.capture();

      // Check if over-scrolling occurred due to undetected folds.
      // Subtract '1' because vscode has scrollOff of minimum 1 for bottom line.
      if (updatedCapture.viewportHeightApprox < this.viewportHeightApprox - 1) {
        const linesToScrollUp = this.viewportHeightApprox - updatedCapture.viewportHeightApprox - 1;
        await scrollLines('up', linesToScrollUp);
        updatedCapture = EditorViewportState.capture();
      }
    } else {
      throw "Invalid argument provided for 'direction'"
    }
    return updatedCapture;
  }

  async moveCursorTo(position) {
    if (this.#outdated) {
      throw "Attempt to use an outdated capture"
    }
    this.#outdated = true;

    let motion;
    let linesToMove = position.line - this.cursorPosition.line;
    if (linesToMove > 0) {
      motion = 'j';
    } else if (linesToMove < 0) {
      linesToMove = -linesToMove;
      motion = 'k';
    } else {
      this.#outdated = false;
      return this;
    }

    // Let Neovim handle the cursor movement, as it preserves the cursor's column position.
    await vscode.commands.executeCommand('vscode-neovim.send', `${linesToMove}${motion}`);
    return EditorViewportState.capture();
  }
}

const scrollDirection = "%s";
if (scrollDirection !== "up" && scrollDirection !== "down") {
  throw "Invalid scrollDirection: must be either 'up' or 'down'";
}

// Scroll the editor
const preScrollCapture = EditorViewportState.capture();
const postScrollCapture = await preScrollCapture.scroll(scrollDirection);
let scrollDelta;
if (scrollDirection === "up") {
  scrollDelta =
    postScrollCapture.offsetFromPosition(preScrollCapture.viewportStart) -
    postScrollCapture.offsetFromPosition(postScrollCapture.viewportStart)
} else if (scrollDirection === "down") {
  scrollDelta =
    preScrollCapture.offsetFromPosition(postScrollCapture.viewportStart) -
    preScrollCapture.offsetFromPosition(preScrollCapture.viewportStart)
}

// Approximate viewport height
let viewportHeightApproxHalf;
if (scrollDirection === "up" && postScrollCapture.isDocumentStartVisible) {
  viewportHeightApproxHalf = postScrollCapture.viewportHeightApproxHalf;
} else if (scrollDirection === "down" && postScrollCapture.isDocumentEndVisible) {
  viewportHeightApproxHalf = preScrollCapture.viewportHeightApproxHalf;
} else {
  viewportHeightApproxHalf = scrollDelta;
}

// Calculate the cursor position to update
const offsetDelta = viewportHeightApproxHalf - scrollDelta;
const preScrollCursorOffset = preScrollCapture.cursorOffset;
let postScrollCursorOffset;
if (scrollDirection === "up") {
  postScrollCursorOffset = Math.max(0, preScrollCursorOffset - offsetDelta);
} else if (scrollDirection === "down") {
  postScrollCursorOffset = Math.min(
    postScrollCapture.viewportHeightApprox - 1,
    preScrollCursorOffset + offsetDelta
  );
}

// Move cursor
const postScrollCursorPosition = postScrollCapture.positionFromOffset(postScrollCursorOffset);
if (postScrollCursorPosition !== null) {
  await postScrollCapture.moveCursorTo(postScrollCursorPosition);
}

 ]], to))
end

local opts = { noremap = true, silent = false }
vim.keymap.set({'n', 'v'}, '<c-u>', function() scrollHalfPage('up') end, opts)
vim.keymap.set({'n', 'v'}, '<c-d>', function() scrollHalfPage('down') end, opts)
