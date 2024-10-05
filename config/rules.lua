-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Load Debian menu entries

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  {
    rule = { class = "firefox-esr", },
    properties = { tag = "1", },
  },

  {
    rule = { class = "kitty", },
    properties = { tag = "2", },
  },

  {
    rule = { class = "Pcmanfm", },
    properties = { tag = "3", },
  },

  {
    rule = { class = "obsidian", },
    properties = { tag = "4", },
  },

  {
    rule = { class = "Zotero", },
    properties = { tag = "5", },
  },

  {
    rule = { class = "KeePassXC", },
    properties = { tag = "6", },
  },

  {
    rule = { class = "teams-for-linux", },
    properties = { tag = "7", },
  },

  {
    rule = { class = "thunderbird", },
    properties = { tag = "8", },
  },

  {
    rule_any = { class = { "discord", "Spotify", }, },
    properties = { tag = "9", },
  },

  -- Right opacity for kitty
  -- not functional
  -- { rule = {class = "kitty" },
  --   properties = { opacity = 1 }
  -- },

  -- Add titlebars to normal clients and dialogs
  -- { rule_any = {type = { "normal", "dialog" }
  --   }, properties = { titlebars_enabled = true }
  -- },
}
-- }}}
