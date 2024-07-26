local settings = require("settings")
local colors = require("colors")

local day_of_week_kanji = {
  "日",
  "月",
  "火",
  "水",
  "木",
  "金",
  "土",
}

sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", "calendar", {
  icon = {
    padding_left = 8,
    font = {
      style = settings.font.style_map["Heavy"],
      size = 12.0,
    },
  },
  label = {
    padding_left = 8,
    padding_right = 8,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
})

sbar.add("bracket", "calendar.bracket", { cal.name }, {
  background = { color = colors.item_background }
})

sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%m月%d日（") .. day_of_week_kanji[os.date("*t").wday] .. "）", label = os.date("%H:%M") })
end)