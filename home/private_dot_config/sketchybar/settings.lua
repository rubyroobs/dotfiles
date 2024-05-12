return {
  paddings = 2,
  group_paddings = 4,

  icons = "sf-symbols",
  app_icons = "JetBrainsMono NF",

  -- -- This is a font configuration for SF Pro and SF Mono (installed manually)
  -- font = require("helpers.default_font"),

  -- Alternatively, this is a font config for JetBrainsMono NF
  font = {
      text = "JetBrainsMono NF",
      numbers = "JetBrainsMono NF",
      style_map = {
          ["Regular"] = "Regular",
          ["Semibold"] = "Medium",
          ["Bold"] = "SemiBold",
          ["Heavy"] = "Bold",
          ["Black"] = "ExtraBold"
      }
  }
}