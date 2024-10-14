# Dotfiles

Personalized configurations for various software.

Included configurations:

- Alacritty
- Neovim
- Tmux
- Vim

## Configuration

> **TIP**: You can create a symbolic link by following command:
>
> ```bash
> # Create a symbolic link using absolute paths for both the source and
> # destination.
>
> # Assume that the repo is located at "~/.local/dotfiles".
> # Example for neovim:
> ln -s ~/.config/nvim ~/.local/dotfiles/nvim
> ```

### Alacritty

You need to replace the font with the installed one in the configuration file.

Place the files as follows:

```
~/.config/alacritty -> /path/to/repo/alacritty/
```

### Neovim

There are some dependencies for plugins, e.g., nvim-lspconfig. See their
documentations.

Place the files as follows:

```
~/.config/nvim -> /path/to/repo/nvim/
```

### Tmux

Place the files as follows:

```
~/.config/tmux -> /path/to/repo/tmux/
```

### Vim

Portable Vim configuration.

Place the files as follows:

```
~/.vim -> /path/to/repo/vim/
```

Or, for recent versions of vim:

```
~/.config/vim -> /path/to/repo/vim/
```

