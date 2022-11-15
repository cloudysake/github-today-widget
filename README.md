# AwesomeWM Github Today Widget

Shows you how many contributions you've made today.

This widget is inspired by the [github-contributions-widget by streetturtle](https://github.com/streetturtle/awesome-wm-widgets/tree/master/github-contributions-widget). I think this widget is great, but there were a few things that I was not satisfied with:

1. The widget relies on the https://github-contributions.now.sh/ API, which means if this website is ever taken down, the widget will be useless.
2. I wanted to specifically view how many contributions I've made today to remind me to commit and push personal projects, which I often forget.
3. The widget uses easy_async instead of watch, which means the widget never updates unless you reload awesomewm. This widget uses watch and refreshes the contributions every 10 minutes by default (and can be changed using the `interval` argument).

Instead of using an external API, this widget relies on GitHub CLI to perform an API call to retrieve the number of contributions for today. 
## Customization

The widget takes the following arguments:

```lua
-- Default arguments
github_today_widget({
  username = '',  -- (Required) Your GitHub username.
  interval = 600, -- Seconds to wait between updates
  left = 0,       -- Widget's left padding
  right = 0,      -- Widget's right padding
  top = 0,        -- Widget's top padding
  bottom = 0,     -- Widget's bottom padding
  colors = {      -- Colors used in the %FG% and %BG% tags (see Tags section below)
    fg = {
      "#ff3c3c",  -- Value of %FG% tag if contributions = 0
      "#9be9a8",  -- Value of %FG% tag if contributions > 0
    },
    bg = {
      "#ff3c3c",  -- Value of %BG% tag if contributions = 0
      "#9be9a8",  -- Value of %BG% tag if contributions > 0
    }
  },
  markup = {
    -- Widget's markup if contributions = 0
    -- (replaces special tags shown in Tags section below).
    '<span foreground="%bg%"><b>No contributions today</b></span>',
    -- Widget's markup if contributions > 0
    -- (replaces special tags shown in Tags section below).
    '<span foreground="%bg%"><b>%COUNT% contribution%plural% today</b></span>',
  }
}),
```

### Tags

The strings used in the `markup` argument accept tags that will be replaced before displaying on the widget.

| Tag | Description |
|---|---|
| `%fg%` | The color defined in the `colors.fg` argument. The first color in `colors.fg` is used if contributions = 0, and the second color is used if contributions > 0. |
| `%bg%` | The color defined in the `colors.bg` argument. The first color in `colors.bg` is used if contributions = 0, and the second color is used if contributions > 0. |
| `%count%` | Replaced with the number of contributions made today. |
| `%plural%` | Replaced with the letter s if exactly one contribution has been made today, and an empty string if the contributions today are anything but one. Used for singular / plural words such as contribution/contributions. |
| `%PLURAL%` | Same as `%plural%`, but capitalized. |

### Screenshots

Default settings, no contributions:
![github-today-default-none.png](./screenshots/github-today-default-none.png)

Default settings, one contribution:
![github-today-default-one.png](./screenshots/github-today-default-one.png)

Default settings, more than one contribution:
![github-today-default-two.png](./screenshots/github-today-default-two.png)

## Installation

Clone/download repo under **~/.config/awesome** and use widget in **rc.lua**:

```lua
-- The widget is installed in ~/.config/awesome/widgets/github-today
local github_today_widget = require("widgets.github-today-widget.github-today-widget")
...
s.mytasklist, -- Middle widget
  { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
	...
    github_today_widget({
      username = '<your username>'
    }),
    ...
  }
```

<br>
Example with arguments:

```lua
-- In this example, the widget is installed in ~.config/awesome/widgets/github
local github_today_widget = require("widgets.github.github-today-widget.github-today-widget")
...
s.mytasklist, -- Middle widget
  { -- Right widgets
    layout = wibox.layout.fixed.horizontal,
    ...
    github_today_widget({
      username = '<your username>',
      left = 10,
      right = 10,
      top = 2,
      bottom = 2,
      colors = {
        fg = {
          "#550000"
          "#004400",
        },
        bg = {
          "#ff8888",
          "#88ff88",
        }
      },
      markup = {
        -- !!!NO CONTRIBUTIONS!!!
        '<span foreground="%fg%" background="%bg%>!!!NO CONTRIBUTIONS!!!</span>',
        --  1: "# CONTRIBUTION!"
        -- 2+: "# CONTRIBUTIONS!"
        '<span foreground="%bg" background="%bg%>%count% CONTRUBUTION%PLURAL%!</span>',
      },
  }),
		...
```

