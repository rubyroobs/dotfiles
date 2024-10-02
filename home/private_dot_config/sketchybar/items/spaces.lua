local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local icon_map = require("helpers.icon_map")

-- Probably not needed if using the Apple log again?
sbar.add("item", { width = 4 })

local item_padding_right = 14
if (settings.no_app_labels) then
  item_padding_right = 0
end

local spaces = {}

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      font = { family = settings.font.numbers },
      string = i,
      padding_left = 10,
      padding_right = 4,
      color = colors.text,
      highlight_color = colors.item_selected_text,
    },
    label = {
      padding_right = item_padding_right,
      color = colors.text,
      highlight_color = colors.item_selected_text,
      font = "sketchybar-app-font:Regular:13.5",
      y_offset = -1,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.item_background,
    },
  })

  spaces[i] = space

  -- Padding space
  sbar.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left= 5,
    padding_right= 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon = { highlight = selected, },
      label = { highlight = selected },
      background = { color = selected and colors.item_selected_background or colors.item_background }
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
  if (settings.no_app_labels) then
    return
  end

  local icon_line = ""
  local no_app = true
  for app, count in pairs(env.INFO.apps) do
    no_app = false
    local lookup = icon_map[app]
    local icon = ((lookup == nil) and icon_map["default"] or lookup)
    icon_line = icon_line .. " " .. icon
  end

  if (no_app) then
    icon_line = "—"
  end
  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.item_background,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.item_background,
  },
  background = {
    color = colors.with_alpha(colors.item_background, 0.0),
    border_color = colors.with_alpha(colors.item_background, 0.0),
  }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.item_background },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.item_background },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
