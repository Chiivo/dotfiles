-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error",
		function (err)
			-- Make sure we don't go into an endless error loop
			if in_error then return end
			in_error = true
			naughty.notify({ preset = naughty.config.presets.critical,
				title = "Oops, an error happened!",
				text = tostring(err)})
			in_error = false
		end
	)
end

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Notification Config
naughty.config.padding = 20
naughty.config.spacing = 10
naughty.config.icon_dirs = {"/home/chivo/.icons/Flatery-Pink-Dark/"}
naughty.config.defaults.margin = 10
naughty.config.defaults.border_width = 4
naughty.config.defaults.timeout = 10
naughty.config.defaults.screen = 1

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("nvim") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt. If you do not like this or do not have such a key, I suggest you to remap Mod4 to another key using xmodmap or other tools. However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	-- awful.layout.suit.floating,
	awful.layout.suit.tile,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}

-- Right Click Menu
-- Create a launcher widget and a main menu
powermenu = {
	{ "Power Off",
		function()
			awful.spawn.with_shell("poweroff")
		end
	},
	{ "Reboot",
		function()
			awful.spawn.with_shell("reboot")
		end
	},
	{ "Logout",
		function()
			awesome.quit()
		end
	}
}
mymainmenu = awful.menu({
	items = {
		{ "Open Terminal", terminal },
		{ "Power Menu", powermenu }
	}
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create Widgets
-- Powermenu Widget
powerbutton = wibox.widget {
	{
		widget = wibox.container.margin,
		top = 10,
		bottom = 10,
		{
			widget = wibox.widget.textbox,
			text = "???",
			valign ="center",
			align = "center"
		}
	},
	layout = wibox.layout.fixed.vertical,
}
powerbutton:buttons(gears.table.join(
	awful.button({ }, 1,
		function ()
			awful.spawn.with_shell("poweroff")
		end
	)
))
-- Tags Widget
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
tags = wibox.widget {
	{
		widget = awful.widget.taglist ({
			screen = 1,
			filter  = awful.widget.taglist.filter.all,
			layout = {
				spacing = 10,
				layout  = wibox.layout.fixed.vertical
			},
			buttons = taglist_buttons
		})
	},
	layout = wibox.layout.fixed.vertical,
}
-- Volume Widget
volume = wibox.widget {
	{
		widget = awful.widget.watch('bash -c "~/scripts/volume -s"', .1),
		valign = "center",
		align = "center"
	},
	layout = wibox.layout.fixed.vertical,
}
volume:buttons(gears.table.join(
	awful.button({ }, 1,
		function ()
			awful.spawn.with_shell("~/scripts/volume -m")
		end
	)
))
-- Clock Widget
clock = wibox.widget {
	{
		widget = wibox.container.margin,
		top = 10,
		{
			widget = wibox.widget.textclock,
			format = "%H",
			valign = "center",
			align = "center"
		}
	},
	{
		widget = wibox.container.margin,
		bottom = 10,
		{
			widget = wibox.widget.textclock,
			format = "%M",
			valign = "center",
			align = "center"
		}
	},
	layout = wibox.layout.fixed.vertical,
}

-- Tags for each screen
awful.screen.connect_for_each_screen(
	function(s)
		awful.tag({ "1", "2", "3" }, s, awful.layout.layouts[1])
	end
)

-- Create the wibox
bar = awful.wibar({
	position = "left",
	height = 1040,
	width = 30,
})
awful.placement.left(bar, { margins = 20 })
bar:struts{ left = 50 }

-- Add widgets to the wibox
bar:setup {
	layout = wibox.layout.align.vertical,
	{-- Left widgets
		layout = wibox.layout.fixed.vertical,
		powerbutton
	},
	{-- Middle widgets
		layout = wibox.container.place,
		tags,
	},
	{ -- Right widgets
		layout = wibox.layout.fixed.vertical,
		volume,
		clock
	}
}

-- Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 3,
		function ()
			mymainmenu:toggle()
		end
	)
	-- awful.button({ }, 4, awful.tag.viewnext),
	-- awful.button({ }, 5, awful.tag.viewprev)
))

-- Global Keybindings
globalkeys = gears.table.join(
	-- Help Screen
	awful.key({ modkey, }, "s",
		hotkeys_popup.show_help,
		{description="show help", group="awesome"}),
	-- Switch Tags
	awful.key({ modkey, }, "Left",
		awful.tag.viewprev,
		{description = "view previous", group = "tag"}),
	awful.key({ modkey, }, "Right",
		awful.tag.viewnext,
		{description = "view next", group = "tag"}),
	awful.key({ modkey, }, "Escape",
		awful.tag.history.restore,
		{description = "go back", group = "tag"}),
	-- Switch Window Focus
	awful.key({ modkey, }, "j",
		function ()
			awful.client.focus.byidx( 1)
		end,
		{description = "focus next by index", group = "client"}
	),
	awful.key({ modkey, }, "k",
		function ()
			awful.client.focus.byidx(-1)
		end,
		{description = "focus previous by index", group = "client"}
	),
	awful.key({ modkey, }, "u",
		awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}
	),
	awful.key({ modkey, }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go back", group = "client"}
	),
	-- Change Window Order
	awful.key({ modkey, "Shift" }, "j",
		function ()
			awful.client.swap.byidx(  1)
		end,
		{description = "swap with next client by index", group = "client"}
	),
	awful.key({ modkey, "Shift" }, "k",
		function ()
			awful.client.swap.byidx( -1)
		end,
		{description = "swap with previous client by index", group = "client"}
	),
	-- Switch Screen Focus
	awful.key({ modkey, }, "h",
		function ()
			awful.screen.focus_relative( 1)
		end,
		{description = "focus the next screen", group = "screen"}
	),
	awful.key({ modkey, }, "l",
		function ()
			awful.screen.focus_relative(-1)
		end,
		{description = "focus the previous screen", group = "screen"}
	),
	-- Resize Windows
	awful.key({ modkey, "Shift" }, "l",
		function ()
			awful.tag.incmwfact( 0.04925)
		end,
		{description = "increase master width factor", group = "layout"}
	),
	awful.key({ modkey, "Shift" }, "h",
		function ()
			awful.tag.incmwfact(-0.04925)
		end,
		{description = "decrease master width factor", group = "layout"}
	),
	-- Right Click Menu with Keybind
	awful.key({ modkey, }, "w",
		function ()
			mymainmenu:show()
		end,
		{description = "show main menu", group = "awesome"}
	),
	-- Open Terminal
	awful.key({ modkey, "Shift" }, "Return",
		function ()
			awful.spawn(terminal)
		end,
		{description = "open a terminal", group = "launcher"}
	),
	-- Reload Awesome
	awful.key({ modkey, }, "q",
		awesome.restart,
		{description = "reload awesome", group = "awesome"}
	),
	-- Quit Awesome
	awful.key({ modkey, "Shift" }, "q",
		awesome.quit,
		{description = "quit awesome", group = "awesome"}
	),
	-- Rofi
	awful.key({ modkey }, "p",
		function()
			awful.spawn("rofi -show")
		end,
		{description = "show rofi", group = "launcher"}
	),
	-- Screenshot
	awful.key({ }, "Print",
		function()
			awful.spawn.with_shell("~/scripts/screenshot -a")
		end,
		{description = "Copy Screenshot", group = "Screenshot"}
	),
	awful.key({ modkey }, "Print",
		function()
			awful.spawn.with_shell("~/scripts/screenshot -f")
		end,
		{description = "Save Clipboard", group = "Screenshot"}
	),
	-- Volume
	awful.key({ }, "XF86AudioRaiseVolume",
		function()
			awful.spawn.with_shell("~/scripts/volume -u")
		end,
		{description = "Volume Up", group = "Volume"}
	),
	awful.key({ }, "XF86AudioLowerVolume",
		function()
			awful.spawn.with_shell("~/scripts/volume -d")
		end,
		{description = "Volume Down", group = "Volume"}
	),
	awful.key({ }, "XF86AudioMute",
		function()
			awful.spawn.with_shell("~/scripts/volume -m")
		end,
		{description = "Mute Volume", group = "Volume"}
	),
	-- Bottom
	awful.key({ modkey, "Shift" }, "Escape",
		function()
			awful.spawn(terminal .. " --class 'Alacritty,Bottom' -e btm")
		end,
		{description = "Spawn Bottom", group = "launcher"}
	),
	-- Scratchpad
	awful.key({ modkey, }, "Return",
		function()
			awful.spawn(terminal .. " --class 'Alacritty,Scratchpad'")
		end,
		{description = "Spawn Scratchpad", group = "launcher"}
	)
)
-- Client Keybindings
clientkeys = gears.table.join(
	-- Set Fullscreen
	awful.key({ modkey, }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}
	),
	-- Close Window
	awful.key({ modkey, "Shift" }, "c",
		function (c)
			c:kill()
		end,
		{description = "close", group = "client"}
	),
	-- Toogle Floating
	awful.key({ modkey, "Control" }, "space",
		awful.client.floating.toggle,
		{description = "toggle floating", group = "client"}
	),
	-- Move to Master
	awful.key({ modkey, "Control" }, "Return",
		function (c)
			c:swap(awful.client.getmaster())
		end,
		{description = "move to master", group = "client"}
	),
	-- Move to Unfocused Screen
	awful.key({ modkey, }, "o",
		function (c)
			c:move_to_screen()
		end,
		{description = "move to screen", group = "client"}
	),
	-- Toggle Keep on Top
	awful.key({ modkey, }, "t",
		function (c)
			c.ontop = not c.ontop
		end,
		{description = "toggle keep on top", group = "client"}
	),
	-- Minimize Window
	awful.key({ modkey, }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus.
			c.minimized = true
		end,
		{description = "minimize", group = "client"}
	),
	-- Unminimized
	awful.key({ modkey, "Control" }, "n",
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", {raise = true}
				)
			end
		end,
		{description = "restore minimized", group = "client"}
	),
	-- Maximize Window
	awful.key({ modkey, }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{description = "(un)maximize", group = "client"}
	),
	-- Unmaximize Window
	awful.key({ modkey, "Control" }, "m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{description = "(un)maximize vertically", group = "client"}
	),
	awful.key({ modkey, "Shift" }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{description = "(un)maximize horizontally", group = "client"}
	)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout. This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tag"}
		),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tag"}
		),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tag"}
		),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "tag"}
		)
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1,
		function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
		end
	),
	awful.button({ modkey }, 1,
		function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.move(c)
		end
	),
	awful.button({ modkey }, 3,
		function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.resize(c)
		end
	)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.centered+awful.placement.no_overlap+awful.placement.no_offscreen,
			size_hints_honor = false
		}
	},
	{ 
		rule = {
			class = "discord"
		},
		properties = {
			screen = 2,
			tag = "1"
		}
	},
	-- Floating clients.
	{
		rule_any = {
			instance = {
				"pinentry"
			},
			class = {
				"Blueman-manager",
				"Nsxiv",
				"Bottom",
				"Scratchpad",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client and the name shown there might not match defined rules here.
			name = {
				"Event Tester",  -- xev.
			},
			role = {
				"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = {
			floating = true
		}
	},
	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = {
				"normal",
				"dialog"
			}
		},
		properties = {
			titlebars_enabled = false
		}
	}
}
	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--  	properties = { screen = 1, tag = "2" } },

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
	function (c)
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		if not awesome.startup then awful.client.setslave(c) end
		if awesome.startup
			and not c.size_hints.user_position
			and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end
	end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars",
	function(c)
		-- buttons for the titlebar
		local buttons = gears.table.join(
			awful.button({ }, 1,
				function()
					c:emit_signal("request::activate", "titlebar", {raise = true})
					awful.mouse.client.move(c)
				end
			),
			awful.button({ }, 3,
				function()
					c:emit_signal("request::activate", "titlebar", {raise = true})
					awful.mouse.client.resize(c)
				end
			)
		)
		awful.titlebar(c) : setup {
			{ -- Left
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout  = wibox.layout.fixed.vertical
			},
			{ -- Middle
				{ -- Title
					align  = "center",
					widget = awful.titlebar.widget.titlewidget(c)
				},
				buttons = buttons,
				layout  = wibox.layout.flex.vertical
			},
			{ -- Right
				awful.titlebar.widget.floatingbutton(c),
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.stickybutton(c),
				awful.titlebar.widget.ontopbutton(c),
				awful.titlebar.widget.closebutton(c),
				layout = wibox.layout.fixed.vertical()
			},
			layout = wibox.layout.align.vertical
		}
	end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
	function(c)
		c:emit_signal("request::activate", "mouse_enter", {raise = false})
	end
)
client.connect_signal("focus",
	function(c)
		c.border_color = beautiful.border_focus
	end
)
client.connect_signal("unfocus",
	function(c)
		c.border_color = beautiful.border_normal
	end
)
-- local function move_mouse_onto_focused_client(c)
-- 	if mouse.object_under_pointer() ~= c then
-- 		local geometry = c:geometry()
-- 		local x = geometry.x + geometry.width/2
-- 		local y = geometry.y + geometry.height/2
-- 		mouse.coords({x = x, y = y}, true)
-- 	end
-- end
-- client.connect_signal("focus", move_mouse_onto_focused_client)

-- Autostart
awful.spawn.with_shell("~/.config/awesome/autostart")
