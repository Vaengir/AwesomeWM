local utils = require("utils")
local widgets = require("widgets")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local current_screen = screen[screen.count()]

-- Layouts, widgets and utilities
local lain = require("lain")

local markup = lain.util.markup

-- Volume
local volicon = wibox.widget.textbox("<span font='Hack 25'>󰕿</span>")
local volume = lain.widget.alsa({
  settings = function()
    if volume_now.status == "off" then
      volicon:set_markup("<span font='Hack 11'>󰝟</span> ")
    elseif tonumber(volume_now.level) == 0 then
      volicon:set_markup("<span font='Hack 11'>󰕿</span> ")
    elseif tonumber(volume_now.level) <= 50 then
      volicon:set_markup("<span font='Hack 11'>󰖀</span> ")
    else
      volicon:set_markup("<span font='Hack 11'>󰕾</span> ")
    end
    widget:set_markup(markup.font(beautiful.font, "" .. volume_now.level .. "% "))
  end,
})
volume.widget:buttons(awful.util.table.join(
  awful.button({}, 4, function()
    awful.util.spawn("amixer set Master 1%+")
    volume.update()
  end),
  awful.button({}, 5, function()
    awful.util.spawn("amixer set Master 1%-")
    volume.update()
  end)
))
-- Clock and Date
local clock = wibox.widget.textclock("<span font='Hack Bold 10'>%H:%M</span>")
local date = wibox.widget.textclock("<span font='Hack Bold 10'>%a %b %d %Y</span>")

-- Calendar
local calendar = widgets.calendar()
date:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    calendar.toggle()
  end
end)

local DEFAULT_OPTS = {
  widget_spacing = beautiful.spacing,
  bg = beautiful.bg_normal,
}

local wrap_bg = function(widgets, opts)
  opts = utils.misc.tbl_override(DEFAULT_OPTS, opts or {})

  if type(widgets) == "table" then
    widgets.spacing = opts.widget_spacing
  end

  return wibox.widget({
    {
      widgets,
      left = beautiful.spacing_xl,
      right = beautiful.spacing_xl,
      top = beautiful.spacing_lg,
      bottom = beautiful.spacing_lg,
      widget = wibox.container.margin,
    },
    shape = utils.ui.rounded_rect(20),
    bg = beautiful.bg_focus,
    widget = wibox.container.background,
  })
end

-- Systray Widget
local systray = wibox.widget.systray()
systray:set_screen(current_screen)
systray:connect_signal("widget::layout_changed", function(st)
  -- hide systray if there are no visible entries
  local visible_entries, _ = awesome.systray()
  st.visible = visible_entries > 0
end)

-- Separators
local spr = wibox.widget.textbox('  ')

-- Wallpaper
local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, false)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", }, s, awful.layout.layouts[1])

  -- Create promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Taglist Icons
  local unfocus_icon = " "
  local empty_icon = " "
  local focus_icon = " "

  local taglist_buttons = gears.table.join(
    awful.button({}, 1,
      function(t) t:view_only() end),
    awful.button({ modkey, }, 1, function(t)
      if client.focus then client.focus:move_to_tag(t) end
    end), awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey, }, 3, function(t)
      if client.focus then client.focus:toggle_tag(t) end
    end), awful.button({}, 4, function(t)
      awful.tag.viewnext(t.screen)
    end), awful.button({}, 5, function(t)
      awful.tag.viewprev(t.screen)
    end))

  -- Function to update the tags
  local update_tags = function(self, c3)
    local tagicon = self:get_children_by_id('icon_role')[1]
    if c3.selected then
      tagicon.text = focus_icon
      self.fg = beautiful.fg_focus
    elseif #c3:clients() == 0 then
      tagicon.text = empty_icon
      self.fg = beautiful.bg_normal
    else
      tagicon.text = unfocus_icon
      self.fg = beautiful.fg_normal
    end
  end

  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      spacing = beautiful.spacing,
      layout = wibox.layout.fixed.horizontal,
    },
    style = {
      shape = gears.shape.circle,
    },
    widget_template = {
      {
        {
          id = 'icon_role',
          font = "Hack Nerd Font 15",
          widget = wibox.widget.textbox,
        },
        id = 'margin_role',
        top = dpi(0),
        bottom = dpi(0),
        left = dpi(2),
        right = dpi(2),
        widget = wibox.container.margin,
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = function(self, c3, index, objects)
        update_tags(self, c3)
      end,
      update_callback = function(self, c3, index, objects)
        update_tags(self, c3)
      end,
    },
    buttons = taglist_buttons,
  }

  -- Create tasklist widget
  local mytasklist = require('config.tasklist')
  s.mytasklist = mytasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.focused,
    buttons = awful.util.tasklist_buttons,
    style = {
      border_width = dpi(2),
      shape = utils.ui.rounded_rect(),
      bg = beautiful.bg_focus,
    },
  }

  -- Create Wibox
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    height = beautiful.bar_height,
    width = "99%",
    opacity = 0.9,
    border_width = dpi(5),
    bg = beautiful.transparent,
    fg = beautiful.fg_normal,
  })


  local function setup_dual_monitors()
    if s == screen.primary then
      s.mywibox:setup {
        layout = wibox.layout.stack,
        {
          layout = wibox.layout.align.horizontal,
          {
            --Left Widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            wrap_bg(s.mytaglist),
            spr,
            wrap_bg(s.mytasklist),
            spr,
          },
          nil,
          {
            -- Right Widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            wrap_bg(systray),
            spr,
            wrap_bg({
              layout = wibox.layout.fixed.horizontal,
              volicon,
              volume.widget,
              widgets.battery(),
            }),
            spr,
            wrap_bg(date),
            spr,
          },
        },
        {
          -- Center Widgets
          wrap_bg(clock),
          valign = "center",
          halign = "center",
          layout = wibox.container.place,
        },
      }
    else
      s.mywibox:setup {
        layout = wibox.layout.stack,
        {
          layout = wibox.layout.align.horizontal,
          {
            --Left Widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            wrap_bg(s.mytaglist),
            spr,
            wrap_bg(s.mytasklist),
            spr,
          },
          nil,
          {
            -- Right Widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            wrap_bg(date),
            spr,
          },
        },
        {
          -- Center Widgets
          wrap_bg(clock),
          valign = "center",
          halign = "center",
          layout = wibox.container.place,
        },
      }
    end
  end

  local function setup_one_monitor()
    s.mywibox:setup {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        {
          --Left Widgets
          layout = wibox.layout.fixed.horizontal,
          spr,
          wrap_bg(s.mytaglist),
          spr,
          wrap_bg(s.mytasklist),
          spr,
        },
        nil,
        {
          -- Right Widgets
          layout = wibox.layout.fixed.horizontal,
          spr,
          wrap_bg(systray),
          spr,
          wrap_bg({
            layout = wibox.layout.fixed.horizontal,
            volicon,
            volume.widget,
            widgets.battery(),
          }),
          spr,
          wrap_bg(date),
          spr,
        },
      },
      {
        -- Center Widgets
        wrap_bg(clock),
        valign = "center",
        halign = "center",
        layout = wibox.container.place,
      },
    }
  end

  if screen.count() > 1 then
    setup_dual_monitors()
  else
    setup_one_monitor()
  end
end)
