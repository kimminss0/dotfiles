return {
  'cormacrelf/dark-notify',
  priority = 1001,
  config = function()
    local dn = require 'dark_notify'
    dn.run()

    -- This is not lazy loaded and the below procedure takes 100 ms to
    -- load, it blocks the UI loading quite a bit.
    -- However, I don't want to see any flicker, so let's do this.
    dn.update()
  end,
}
