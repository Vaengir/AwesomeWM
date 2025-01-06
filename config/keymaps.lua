-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Notification library
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Local Variable
local terminal = "ghostty"
local browser = "firefox-esr"
local fileexp = "pcmanfm"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome", }),

  -- Client changing
  awful.key({ modkey, }, "h", function() awful.client.focus.bydirection("left") end,
    { description = "focus client to the left", group = "client", }),
  awful.key({ modkey, }, "j", function() awful.client.focus.bydirection("down") end,
    { description = "focus client on the bottom", group = "client", }),
  awful.key({ modkey, }, "k", function() awful.client.focus.bydirection("up") end,
    { description = "focus client on top", group = "client", }),
  awful.key({ modkey, }, "l", function() awful.client.focus.bydirection("right") end,
    { description = "focus client to the right", group = "client", }),

  -- Layout manipulation
  awful.key({ modkey, "Shift", }, "h", function() awful.client.swap.bydirection("left") end,
    { description = "swap with client to the left", group = "client", }),
  awful.key({ modkey, "Shift", }, "j", function() awful.client.swap.bydirection("down") end,
    { description = "swap with client on the bottom", group = "client", }),
  awful.key({ modkey, "Shift", }, "k", function() awful.client.swap.bydirection("up") end,
    { description = "swap with client on the top", group = "client", }),
  awful.key({ modkey, "Shift", }, "l", function() awful.client.swap.bydirection("right") end,
    { description = "swap with client to the right", group = "client", }),
  awful.key({ modkey, "Control", }, "h", function() awful.screen.focus_bydirection("left") end,
    { description = "focus the screen on the left", group = "screen", }),
  awful.key({ modkey, "Control", }, "j", function() awful.screen.focus_bydirection("down") end,
    { description = "focus the screen on the bottom", group = "screen", }),
  awful.key({ modkey, "Control", }, "k", function() awful.screen.focus_bydirection("up") end,
    { description = "focus the screen on top", group = "screen", }),
  awful.key({ modkey, "Control", }, "l", function() awful.screen.focus_bydirection("right") end,
    { description = "focus the screen on the right", group = "screen", }),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client", }),

  awful.key({ modkey, }, "Up", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout", }),
  awful.key({ modkey, }, "Down", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout", }),
  awful.key({ modkey, }, "Right", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout", }),
  awful.key({ modkey, }, "Left", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout", }),
  awful.key({ modkey, "Control", }, "Up", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout", }),
  awful.key({ modkey, "Control", }, "Down", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout", }),

  awful.key({ modkey, "Control", }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true, }
        )
      end
    end,
    { description = "restore minimized", group = "client", }),

  -- Standard program
  awful.key({ modkey, }, "t", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher", }),
  awful.key({ modkey, "Control", }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome", }),
  awful.key({ modkey, }, "b", function() awful.spawn(browser) end,
    { description = "open the browser", group = "launcher", }),
  awful.key({ modkey, }, "e", function() awful.spawn(fileexp) end,
    { description = "open the file explorer", group = "launcher", }),
  awful.key({ modkey, }, "q", function() awful.util.spawn_with_shell("i3lock-fancy -gp") end,
    { description = "lock screen", group = "awesome", }),

  -- Rofi
  awful.key({ modkey, }, "r", function() awful.util.spawn_with_shell('rofi -combi-modi drun,run -show combi') end,
    { description = "Run Rofi", group = "launcher", }),

  -- Sound and Brightness keybinds
  awful.key({}, "#121", function() awful.util.spawn_with_shell("amixer -q set Master toggle") end,
    { description = "toggle mute", group = "hotkeys", }),
  awful.key({}, "#122", function() awful.util.spawn_with_shell("amixer -q set Master 5%-") end,
    { description = "Volume Down", group = "hotkeys", }),
  awful.key({}, "#123", function() awful.util.spawn_with_shell("amixer -q set Master 5%+") end,
    { description = "Volume Up", group = "hotkeys", }),
  awful.key({}, "#232", function() awful.util.spawn_with_shell("xbacklight -dec 5") end,
    { description = "Volume Down", group = "hotkeys", }),
  awful.key({}, "#233", function() awful.util.spawn_with_shell("xbacklight -inc 5") end,
    { description = "Volume Up", group = "hotkeys", }),

  -- Opacity Change
  awful.key({ modkey, "Shift", }, "o", function()
      local c = client.focus
      if c.opacity == 0.95 then
        c.opacity = 1
      else
        c.opacity = 0.95
      end
    end,
    { description = "Toggle window Opacity", group = "client", })
)

clientkeys = gears.table.join(
  awful.key({ modkey, }, "m",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client", }),
  awful.key({ modkey, }, "c", function(c) c:kill() end,
    { description = "close", group = "client", }),
  awful.key({ modkey, }, "f", awful.client.floating.toggle,
    { description = "toggle floating", group = "client", }),
  awful.key({ modkey, "Control", }, "Return", function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client", }),
  awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
    { description = "move to screen", group = "client", }),

  awful.key({ modkey, }, "n",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client", }),
  awful.key({ modkey, "Control", }, "m",
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client", }),
  awful.key({ modkey, "Shift", }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client", })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey, }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag", }),

    -- Toggle tag display.
    awful.key({ modkey, "Control", }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag", }),

    -- Move client to tag.
    awful.key({ modkey, "Shift", }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag", }),

    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift", }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag", })
  )
end

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
  end),
  awful.button({ modkey, }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey, }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
