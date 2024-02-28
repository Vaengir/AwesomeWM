local naughty                         = require("naughty")
local utils                           = require("utils")

local themes_path                     = (require("gears.filesystem").get_configuration_dir() .. "themes/")
local dpi                             = require("beautiful.xresources").apply_dpi

-- Main
local theme                           = {}
theme.wallpaper                       = themes_path .. "nord/background.jpg"

-- Styles
theme.font                            = "Hack 11"

-- Colors
theme.transparent                     = "#00000000"
theme.fg_normal                       = "#ECEFF4"
theme.fg_focus                        = "#B48EAD"
theme.fg_urgent                       = "#D08770"
theme.bg_normal                       = "#2E3440"
theme.bg_focus                        = "#3B4252"
theme.bg_urgent                       = "#3B4252"

-- Spacing
theme.spacing                         = dpi(5)
theme.spacing_lg                      = dpi(8)
theme.spacing_xl                      = dpi(10)

-- Borders
theme.useless_gap                     = dpi(5)
theme.border_width                    = dpi(3.5)
theme.border_radius                   = dpi(5)
theme.border_normal                   = "#3B4252"
theme.border_focus                    = "#B48EAD"

-- Titlebars
theme.titlebar_bg_focus               = "#3B4252"
theme.titlebar_bg_normal              = "#2E3440"

-- Taglist
theme.taglist_bg_normal               = theme.bg_normal
theme.taglist_bg_focus                = theme.bg_focus

-- Bar
theme.bar_height                      = dpi(35)

-- Tasklist Theme
theme.tasklist_plain_task_name        = false
theme.tasklist_disable_task_name      = false
theme.tasklist_bg_focus               = theme.bg_focus
theme.tasklist_disable_icon           = false

-- Systray
theme.systray_icon_spacing            = 5
theme.bg_systray                      = theme.bg_focus

-- Widgets
theme.battery_happy                   = theme.fg_normal
theme.battery_tired                   = "#ebcb8b"
theme.battery_sad                     = "#bf616a"
theme.battery_charging                = "#a3be8c"

-- Naughty
naughty.config.defaults.ontop         = true
naughty.config.defaults.icon_size     = dpi(100)
naughty.config.defaults.timeout       = 10
naughty.config.defaults.hover_timeout = 300
naughty.config.defaults.margin        = dpi(16)
naughty.config.defaults.border_width  = dpi(4)
naughty.config.defaults.border_color  = theme.border_focus
naughty.config.defaults.position      = 'top_right'
naughty.config.defaults.width         = dpi(400)
naughty.config.defaults.height        = dpi(150)
naughty.config.defaults.shape         = utils.ui.rounded_rect(20)
naughty.config.presets.critical.bg    = theme.battery_sad

-- calendar
theme.calendar_fg_header              = theme.fg_normal
theme.calendar_fg_focus               = theme.bg_normal
theme.calendar_fg_weekday             = theme.fg_focus
theme.calendar_fg                     = theme.fg_normal
theme.calendar_bg                     = theme.bg_normal
theme.calendar_bg_focus               = theme.fg_focus

return theme
