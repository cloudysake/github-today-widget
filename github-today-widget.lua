-------------------------------------------------------------------------------
-- Github Today Widget by xorid
-- Shows how many contributions you've made today.

-- https://github.com/xorid/awesomewm-github-today-contributions
-------------------------------------------------------------------------------
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local filepath = (...):match("(.-)[^%.]+$")
local json = require(filepath .. ".lib.json.json")
-- require(filepath .. ".lib.json.json-beautify")

local github_contributions_widget = {}

local function worker(user_args)
	local default_colors = {
		fg = {
			"#ff3c3c",
			"#9be9a8",
		},
		bg = {
			"#ff3c3c",
			"#9be9a8",
		}
	}
	local default_markup = {
		'<span foreground="%fg%"><b>No contributions today</b></span>',
		'<span foreground="%fg%"><b>%count% contribution%plural% today</b></span>',
	}
	local args = user_args or {}
	local username = args.username or ''
	local left = args.left or 0
	local right = args.right or 0
	local top = args.top or 0
	local bottom = args.top or 0
	local colors = args.colors or default_colors
	local markup = args.markup or default_markup

	local date = os.date("%Y-%m-%d")
	local TODAY_CONTRIBUTIONS_CMD = 'bash -c "gh api graphql -f query=\'query { user(login: \\"xorid\\") { contributionsCollection(from: \\"' .. date .. 'T05:00:00Z\\", to: \\"' .. date .. 'T05:00:00Z\\") { contributionCalendar { weeks { contributionDays { contributionCount date weekday } } } } } }\'"'

	local create_text = function(contribs)
		local key = contribs < 1 and 1 or 2
		local text = markup[key]
		text = text:gsub("%%fg%%", colors.fg[key])
		text = text:gsub("%%bg%%", colors.fg[key])
		text = text:gsub("%%count%%", contribs)
		text = text:gsub("%%plural%%", contribs == 1 and '' or 's')
		text = text:gsub("%%PLURAL%%", contribs == 1 and '' or 'S')
		return text
	end

	local update_widget = function(widget, stdout, _, _, _)
		local data = json.decode(stdout)["data"]
		local today = data["user"]["contributionsCollection"]["contributionCalendar"]["weeks"][1]["contributionDays"][1]
		local contribs = today["contributionCount"]

		-- assert(false, "out: " .. json.beautify(today))
		local text = create_text(contribs)
		local textbox = widget:get_children_by_id("today")[1]
		textbox.markup = text
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
