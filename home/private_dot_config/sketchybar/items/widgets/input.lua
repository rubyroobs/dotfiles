local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.add("event", "language_change", "AppleSelectedInputSourcesChangedNotification")

local input = sbar.add("item", "widgets.input", {
  position = "right",
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
  label = {
    padding_left = 10,
    padding_right = 10,
    align = "right",
    font = { family = settings.font.numbers },
  },
  popup = { align = "center" }
})

function refresh_language()
  sbar.exec("macism", function(lang_out)
    local lang = "?"

    local en, _, _ = lang_out:find('ABC')
    local ja, _, _ = lang_out:find('Japanese')
    local kr, _, _ = lang_out:find('Korean')

    if en then
      lang = "A"
    elseif ja then
      lang = "あ"
    elseif kr then
      lang = "한"
    end

    input:set({
      label = {
        string = lang
      },
    })
  end)
end

input:subscribe({"language_change"}, function()
  refresh_language()
end)

refresh_language()

sbar.add("bracket", "widgets.input.bracket", { input.name }, {
  background = { color = colors.item_background }
})

sbar.add("item", "widgets.input.padding", {
  position = "right",
  width = 4
})
