-------------------------------------------------------------------------------
-- Github Today Widget by xorid
-- Shows how many contributions you've made today.

-- https://github.com/xorid/awesomewm-github-today-contributions
-------------------------------------------------------------------------------
local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local config_dir = gfs.get_configuration_dir()

local github_contributions_widget = {}

local function worker(user_args)
	local args = user_args or {}
	local username = args.username or ''
	local left = args.left or 0
	local right = args.right or 0
	local top = args.top or 0
	local bottom = args.top or 0
	local widget_path = args.widget_path or 'widgets'
	local no_contrib_markup = args.no_contrib_markup or '<span foreground="#ff3c3c"><b>%s</b></span>'
	local no_contrib_text =  args.no_contrib_text or "No contributions today"
	local contrib_markup = args.contrib_markup or '<span foreground="#9be9a8"><b>%s</b></span>'
	local contrib_text = args.contrib_text or "%s %s today"

	local TODAY_CONTRIBUTIONS_CMD = 'bash -c "' .. config_dir .. widget_path .. '/github-today-widget/api/github-today %s"'

	local update_widget = function(widget, stdout, _, _, _)
		local contribs = tonumber(stdout)
		local markup
		local textbox = widget:get_children_by_id("today")[1]

		if contribs < 1 then
			markup = string.format(no_contrib_markup, no_contrib_text)
		else
			markup = string.format(
				contrib_markup,
				string.format(
					contrib_text,
					contribs,
					contribs == 1 and 'contribution' or 'contributions'
				)
			)
		end

		textbox.markup = markup
	end

	github_contributions_widget = wibox.widget(
		{
			{
				id = "today",
				markup = "Loading...",
				widget = wibox.widget.textbox
			},
			left = left,
			right = right,
			bottom = bottom,
			top = top,
			widget = wibox.container.margin
		}
	)

	watch(string.format(TODAY_CONTRIBUTIONS_CMD, username), 600, -- 600 = 10 minutes
		function(widget, stdout)
			update_widget(widget, stdout)
		end, github_contributions_widget)

	return github_contributions_widget
end

return setmetatable(github_contributions_widget, { __call = function(_, ...) return worker(...) end })
