local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
    updates = "when_shown",
    icon = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 13.5
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
        background = {
            image = {
                corner_radius = 12
            }
        }
    },
    label = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 13.0
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings
    },
    background = {
        height = 32,
        corner_radius = 12,
        border_width = 2,
        border_color = colors.white,
        color = colors.bg,
        image = {
            corner_radius = 12,
            border_color = colors.white,
            border_width = 1
        }
    },
    popup = {
        background = {
            border_width = 2,
            corner_radius = 12,
            border_color = colors.white,
            color = colors.bg,
            shadow = {
                drawing = true
            }
        },
        blur_radius = 50
    },
    padding_left = 2,
    padding_right = 2,
    scroll_texts = true
})
