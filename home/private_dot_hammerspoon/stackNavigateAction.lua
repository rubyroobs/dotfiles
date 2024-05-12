local c = require("hs.canvas")
local json = require("hs.json")
local yabai = require("yabai")

local stackNavigateAction = {
    new = function(modKeys, pressedKey, pressedDirection, oppositeKey, oppositeDirection)
        local a = {
            pressedDirection = pressedDirection,
            selected = nil,
            visible = false,
            redrawing = false,
            navigating = false,
        }
        a.modal = hs.hotkey.modal.new(modKeys, pressedKey)
        a.modalCloseTimer = hs.timer.new(0, function () a.modal:exit() end)
        function a:resetModalCloseTimer()
          a.modalCloseTimer:setNextTrigger(stackItemTimeoutSeconds)
        end
        function a.modal:entered()
            yabai({"-m", "query", "--windows", "--window"}, function(out)
                local window = json.decode(out)
                if window ~= nil then
                    a:yabaiNavigate(a.pressedDirection)
                    a.selected = window
                    a:showOverlay()
                    a:resetModalCloseTimer()
                else
                    a.modal:exit()
                end
            end)
        end
        a.modal:bind(modKeys, pressedKey, function()
          a:yabaiNavigate(pressedDirection)
          a:resetModalCloseTimer()
        end)
        a.modal:bind(modKeys, oppositeKey, function()
          a:yabaiNavigate(oppositeDirection)
          a:resetModalCloseTimer()
        end)
        function a.modal:exited()
            a.selected = nil
            a:hideOverlay()
        end
        a.modal:bind(nil, hs.keycodes.map["escape"], function()
            a.modal:exit()
        end)
        function a:yabaiNavigate(direction)
          if self.navigating then return end
          self.navigating = true
          local fallback = "last"
          if direction == "next" then
            fallback = "first"
          end

          yabai({"-m", "window", "--focus", "stack." .. direction}, function(stdout, stderr)
            if stderr ~= "" then
                yabai({"-m", "window", "--focus", "stack." .. fallback}, function()
                    self.navigating = false
                    a:updateCanvas()
                    return true
                end)
            else
                self.navigating = false
                a:updateCanvas()
            end
            return true
          end)
        end
        a.canvas = c.new({
            x = 0,
            y = 0,
            w = 100,
            h = 100
        })
        function a:updateCanvas()
          if self.visible == false then return end
          if self.selected == nil then return end
          if self.redrawing then return end
          self.redrawing = true
          yabai({"-m", "query", "--windows", "--space"}, function(out)
            if out ~= nil or type(out) == "string" and string.len(out) ~= 0 then
              out = string.gsub(out, ":inf,", ":0.0,")
              local json = "{\"windows\":"..out.."}"
              local json_obj = hs.json.decode(json)
              if json_obj ~= nil then
                local split_type_child_windows = {}
                local stack_windows = {}
                local focused_stack_group = nil

                for _, window in pairs(json_obj.windows) do
                    local window_stack_group = window["split-type"] .. ":" .. window["split-child"]
                    if window["has-focus"] == true then
                        focused_stack_group = window_stack_group
                    end
                    if split_type_child_windows[window_stack_group] == nil then
                        split_type_child_windows[window_stack_group] = {}
                    end
                    table.insert(split_type_child_windows[window_stack_group], window)
                end

                local stack_window_indexes = {}
                for _, window in pairs(split_type_child_windows[focused_stack_group]) do
                    stack_windows[window["stack-index"]] = window
                    table.insert(stack_window_indexes, window["stack-index"])
                end
                table.sort(stack_window_indexes)

                local elements = {}
                for _, idx in ipairs(stack_window_indexes) do
                    local window = stack_windows[idx]
                    table.insert(
                        elements,
                        {
                            type = "rectangle",
                            strokeColor = {
                                red = (window["has-focus"] and {0.9059} or {0.7098})[1],
                                green = (window["has-focus"] and {0.5098} or {0.7490})[1],
                                blue = (window["has-focus"] and {0.5176} or {0.8863})[1],
                            },
                            fillColor = {
                                red = 0.1882,
                                green = 0.2039,
                                blue = 0.2745,
                            },
                            frame = {
                                x = stackItemMargin,
                                y = stackItemMargin + ((idx - 1) * stackItemHeight * stackItemVerticalSpace),
                                h = stackItemHeight,
                                w = self.selected.frame.w - (stackItemMargin * 2),
                            },
                            roundedRectRadii = {
                                xRadius = windowCornerRadius,
                                yRadius = windowCornerRadius
                            },
                        }
                    )
                    local appText = hs.styledtext.new(window["app"] .. " - " .. window["title"], {
                        color = {
                            red = (window["has-focus"] and {0.9059} or {0.7098})[1],
                            green = (window["has-focus"] and {0.5098} or {0.7490})[1],
                            blue = (window["has-focus"] and {0.5176} or {0.8863})[1],
                        },
                        font = {
                            name = "JetBrainsMono NF",
                            size = 13.0,
                        },
                        paragraphStyle = {
                            alignment = "center",
                        }
                    })
                    local appTextSize = hs.drawing.getTextDrawingSize(appText)
                    table.insert(
                        elements,
                        {
                            type = "text",
                            text = appText,
                            frame = {
                                x = stackItemMargin,
                                y = stackItemMargin + ((idx - 1) * stackItemHeight * stackItemVerticalSpace) + ((stackItemHeight / 2) - (appTextSize.h / 2)),
                                h = appTextSize.h,
                                w = self.selected.frame.w - (stackItemMargin * 2),
                            },
                        }
                    )
                end
                self.canvas:replaceElements(table.unpack(elements))
              end
            end

            self.redrawing = false
          end)
        end
        function a:showOverlay()
            self.visible = true
            self.canvas:topLeft({
                x = self.selected.frame.x,
                y = self.selected.frame.y
            }):size({
                w = self.selected.frame.w,
                h = self.selected.frame.h
            }):show()
        end
        function a:hideOverlay()
            self.visible = false
            self.canvas:hide()
        end
        return a
    end
}
return stackNavigateAction