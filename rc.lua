local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
require("awful.hotkeys_popup.keys")

local utils = require("utils")

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/nord/theme.lua")

awful.layout.layouts = {
  -- awful.layout.suit.tile,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile.bottom,
  -- awful.layout.suit.floating,
  -- awful.layout.suit.max,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

require "config.wibar"
require "config.keymaps"
require "config.rules"

client.connect_signal("manage", function(c)
  c.shape = utils.ui.rounded_rect(20)
  c.opacity = 0.95
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)

-- Active window border color
client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false, })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("manage", function(c)
  if c.class == nil then
    c.minimized = true
    c:connect_signal("property::class", function()
      c.minimized = false
      awful.rules.apply(c)
    end)
  end
end)

naughty.config.notify_callback = function(n)
  n.timeout = 0
  return n
end

-- Autostart --
awful.util.spawn_with_shell("~/.local/bin/startup.sh")
-- Update all Repos on Awesome Reload
-- npm install gitfox -g
-- awful.util.spawn_with_shell("g pull ~/git/")
