require("hs.ipc")


--# constants
super = {"alt"}
superShift = {"alt", "shift"}
empty_table = {}
windowCornerRadius = 10
stackItemHeight = 32.0
stackItemVerticalSpace = 1.2
stackItemMargin = 4.0
stackItemTimeoutSeconds = 1.0

--# images
local images = require("images")

--# canvas elements
local canvases = {
  winFocusRect = hs.canvas.new({ x = 0, y = 0, w = 100, h = 100 }),
}


local focus_ = {
  --hideTimer = nil
}


--# helpers
function yabai(args, completion)
  local yabai_output = ""
  local yabai_error = ""
  local yabai_task = hs.task.new("/opt/homebrew/bin/yabai", nil, function(task, stdout, stderr)
    if stdout ~= nil then yabai_output = yabai_output..stdout end
    if stderr ~= nil then yabai_error = yabai_error..stderr end
    return true
  end, args)
  if type(completion) == "function" then
    yabai_task:setCallback(function() completion(yabai_output, yabai_error) end)
  end
  yabai_task:start()
end

function delayed(fn, delay)
  return hs.timer.delayed.new(delay, fn):start()
end


toasts = {
  main = nil
}
function killToast(params)
  params = params or empty_table
  local name = params.name or "main"
  if toasts[name] ~= nil then
    hs.alert.closeSpecific(toasts[name], params.fadeOutDuration or 0.1)
    toasts[name] = nil
  end
end
function toast(str, time, params)
  killToast(params)
  params = params or empty_table
  local name = params.name or "main"
  --local toast = toasts[name]
  toasts[name] = hs.alert(str, {
    fillColor = { white = 0, alpha = 0.4 },
    strokeColor = { white = 0, alpha = 0 },
    strokeWidth = 0,
    textColor = { white = 1, alpha = 1 },
    radius = 0,
    padding = 6,
    atScreenEdge = 0,
    fadeInDuration = 0.1,
    fadeOutDuration = params.fadeOutDuration or 0.1
  }, time or 0.6)
end


--# Main chooser
local mainChooser = hs.chooser.new(function(option)
  if option ~= nil then
    if option.action == "reload" then
      hs.reload()
    elseif option.action == "toggle_gap" then
      yabai({"-m", "space", "--toggle", "padding"}, function() yabai({"-m", "space", "--toggle", "gap"}) end)
    end
  end
end):choices({
  {
    text = "Toggle Gap",
    subText = "Toggles padding and gaps around the current space",
    action = "toggle_gap"
  },
  {
    text = "Reload",
    subText = "Reload Hammerspoon configuration",
    action = "reload"
  },
})


--# bindings

--# reload config
hs.hotkey.bind(superShift, hs.keycodes.map["r"], nil, function() hs.reload() end)
--# open main chooser (not using rn)
-- hs.hotkey.bind(super, hs.keycodes.map["space"], nil, function() mainChooser:show() end)

--# Space navigation (1 to 9: space by index)
local spaceIcons = {
  "1️⃣",
  "2️⃣",
  "3️⃣",
  "4️⃣",
  "5️⃣",
  "6️⃣",
  "7️⃣",
  "8️⃣",
  "9️⃣"
}

for i, toastStr in ipairs(spaceIcons) do
  local spaceIdx = i .. ""
  hs.hotkey.bind(super, hs.keycodes.map[spaceIdx], function() yabai({"-m", "space", "--focus", spaceIdx}, function() return true end) end)
  hs.hotkey.bind(superShift, hs.keycodes.map[spaceIdx], function() yabai({"-m", "window", "--space", spaceIdx}, function() return true end) end)
end

--# Open terminal
hs.hotkey.bind(super, hs.keycodes.map["return"], function() hs.task.new("/Applications/kitty.app/Contents/MacOS/kitty", nil, function() end, {"--single-instance", "-d", "~"}):start() end, "test")

--# Set layout under mouse
hs.hotkey.bind(super, hs.keycodes.map["q"], function() yabai({"-m", "space", "mouse", "--layout", "bsp"}, function() toast("bsp") end) end)
hs.hotkey.bind(super, hs.keycodes.map["w"], function() yabai({"-m", "space", "mouse", "--layout", "stack"}, function() toast("stack") end) end)

--# Balance bsp
hs.hotkey.bind(super, hs.keycodes.map["e"], function() yabai({"-m", "space", "--balance"}) toast("bsp balanced") end)

--# Focus fullscreen
hs.hotkey.bind(super, hs.keycodes.map["f"], function() yabai({"-m", "window", "--toggle", "zoom-fullscreen"}) end)

--# Toggle gaps yabai -m space --toggle gap
hs.hotkey.bind(super, hs.keycodes.map["g"], function() yabai({"-m", "space", "--toggle", "gap"}) end)

--# Window focus navigation
hs.hotkey.bind(super, hs.keycodes.map["h"], function() yabai({"-m", "window", "--focus", "west"}) end)
hs.hotkey.bind(super, hs.keycodes.map["j"], function() yabai({"-m", "window", "--focus", "north"}) end)
hs.hotkey.bind(super, hs.keycodes.map["k"], function() yabai({"-m", "window", "--focus", "south"}) end)
hs.hotkey.bind(super, hs.keycodes.map["l"], function() yabai({"-m", "window", "--focus", "east"}) end)

--# Move focused window navigation
hs.hotkey.bind(superShift, hs.keycodes.map["h"], function() yabai({"-m", "window", "--warp", "west"}) end)
hs.hotkey.bind(superShift, hs.keycodes.map["j"], function() yabai({"-m", "window", "--warp", "north"}) end)
hs.hotkey.bind(superShift, hs.keycodes.map["k"], function() yabai({"-m", "window", "--warp", "south"}) end)
hs.hotkey.bind(superShift, hs.keycodes.map["l"], function() yabai({"-m", "window", "--warp", "east"}) end)

--# Toggle float for window
hs.hotkey.bind(superShift, hs.keycodes.map["space"], function() yabai({"-m", "window", "--toggle", "float"}) return true end)

--# modals and overlays
local resize_window_modal = hs.hotkey.modal.new(super, hs.keycodes.map["r"])
local stackNavigateAction = require("stackNavigateAction")
stack_navigate_prev = stackNavigateAction.new(super, hs.keycodes.map["d"], "prev", hs.keycodes.map["c"], "next")
stack_navigate_next = stackNavigateAction.new(super, hs.keycodes.map["c"], "next", hs.keycodes.map["d"], "prev")
local windowAction = require("windowAction")
window_action_stack = windowAction.new(super, hs.keycodes.map["s"], "stack", images.stack)

function closeModals()
  if resize_window_modal ~= nil then resize_window_modal:exit() end
  if stack_navigate_prev ~= nil then stack_navigate_prev.modal:exit() end
  if stack_navigate_next ~= nil then stack_navigate_next.modal:exit() end
  if window_action_stack ~= nil then window_action_stack.modal:exit() end
end

function redrawModals()
  if stack_navigate_next ~= nil then stack_navigate_next:updateCanvas() end
  if stack_navigate_prev ~= nil then stack_navigate_prev:updateCanvas() end
end

--# resize window
local resize_window = {
  size = 20,
  horizontalEdge = nil, -- 1 is for right, -1 is for left
  verticalEdge = nil -- 1 is for bottom, -1 is for top
}
function resize_window_modal:entered()
  toast("resize", true, { name = "resize_window" })
end
function resize_window_modal:exited()
  resize_window.horizontalEdge = nil
  resize_window.verticalEdge = nil
  killToast({ name = "resize_window" })
end
resize_window_modal:bind(super, hs.keycodes.map["h"], function()
  if resize_window.horizontalEdge == nil then
    resize_window.horizontalEdge = -1
  end
  if resize_window.horizontalEdge == 1 then
    -- shrink from right
    yabai({"-m", "window", "--resize", "right:-"..resize_window.size..":0"}, function(out, err) return true end)
  else
    -- grow from left
    yabai({"-m", "window", "--resize", "left:-"..resize_window.size..":0"}, function(out, err) return true end)
  end
end)
resize_window_modal:bind(super, hs.keycodes.map["j"], function()
  if resize_window.verticalEdge == nil then
    resize_window.verticalEdge = 1
  end
  if resize_window.verticalEdge == 1 then
    -- grow from bottom
    yabai({"-m", "window", "--resize", "bottom:0:"..resize_window.size}, function(out, err) return true end)
  else
    -- shrink from top
    yabai({"-m", "window", "--resize", "top:0:"..resize_window.size}, function(out, err) return true end)
  end
end)
resize_window_modal:bind(super, hs.keycodes.map["k"], function()
  if resize_window.verticalEdge == nil then
    resize_window.verticalEdge = -1
  end
  if resize_window.verticalEdge == 1 then
    -- shrink from bottom
    yabai({"-m", "window", "--resize", "bottom:0:-"..resize_window.size}, function(out, err) return true end)
  else
    -- grow from top
    yabai({"-m", "window", "--resize", "top:0:-"..resize_window.size}, function(out, err) return true end)
  end
end)
resize_window_modal:bind(super, hs.keycodes.map["l"], function()
  if resize_window.horizontalEdge == nil then
    resize_window.horizontalEdge = 1
  end
  if resize_window.horizontalEdge == 1 then
    -- grow from right
    yabai({"-m", "window", "--resize", "right:"..resize_window.size..":0"}, function(out, err) return true end)
  else
    -- shrink from left
    yabai({"-m", "window", "--resize", "left:"..resize_window.size..":0"}, function(out, err) return true end)
  end
end)
resize_window_modal:bind("", hs.keycodes.map["escape"], function() resize_window_modal:exit() end)

hs.ipc.cliInstall()

yabaidirectcall = {
  window_focused = function(window_id) -- called when another window from the current app is focused
    redrawModals()
  end,
  application_activated = function(process_id) -- called when a window from a different app is focused. Doesn’t exclude a window_focused call.
    redrawModals()
  end,
  window_resized = function(window_id) -- called when a window changes dimensions
    redrawModals()
  end,
  window_moved = function(window_id) -- called when a window is moved
    redrawModals()
  end,
  space_changed = function(space_id)
    closeModals()
  end,
  display_changed = function(display_id)
    closeModals()
  end,
  mission_control_enter = function()
    closeModals()
  end
}
