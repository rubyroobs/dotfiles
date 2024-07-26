local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "window",
  height = 24,
  color = colors.bar_background,
  padding_right = 10,
  padding_left = 10,
})
