local c = require("hs.canvas")
local json = require("hs.json")
local yabai = require("yabai")

local stackNavigateAction = {
    new = function(modKeys, pressedKey, pressedDirection, oppositeKey, oppositeDirection)
        local a = {
            pressedDirection = pressedDirection,
            selected = nil
        }
        a.modal = hs.hotkey.modal.new(modKeys, pressedKey)
        a.modalCloseTimer = hs.timer.new(0, function () a.modal:exit() end)
        function a:resetModalCloseTimer()
          a.modalCloseTimer:setNextTrigger(3)
        end
        function a.modal:entered()
            yabai({"-m", "query", "--windows", "--window"}, function(out)
                local window = json.decode(out)
                if window ~= nil then
                    a:yabaiNavigate(a.pressedDirection)
                    a.selected = window
                    a:updateCanvas()
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
          local fallback = "last"
          if direction == "next" then
            fallback = "first"
          end

          yabai({"-m", "window", "--focus", "stack." .. direction}, function(stdout, stderr)
            if stderr ~= "" then
              self:updateCanvas()
              yabai({"-m", "window", "--focus", "stack." .. fallback}, function() return true end)
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
          yabai({"-m", "query", "--windows", "--space"}, function(out)
            if out ~= nil or type(out) == "string" and string.len(out) ~= 0 then
              out = string.gsub(out, ":inf,", ":0.0,")
              local json = "{\"windows\":"..out.."}"
              local json_obj = hs.json.decode(json)
              if json_obj ~= nil then
                local split_type_child_windows = {}
                local stack_windows = {}

                for _, window in pairs(json_obj.windows)
                  print(window)
                end

                -- TODO: group by split-type/split-child and note the split-type/split-child of focused window
                -- then get rid of remaining windows that aren't in the same split-type/split-child as focused window
                -- then sort by stack-index

              end
            end
          end)
          self.canvas:replaceElements({
              type = "rectangle",
              action = "fill",
              fillColor = {
                  red = 1,
                  alpha = 0.66
              },
              frame = {
                x = "0%",
                y = "10%",
                h = "10%",
                w = "100%",
              },
              roundedRectRadii = {
                  xRadius = windowCornerRadius,
                  yRadius = windowCornerRadius
              },
              compositeRule = "plusDarker",
          }, {
              type = "rectangle",
              action = "fill",
              fillColor = {
                  white = 1,
                  alpha = 0.66
              },
              roundedRectRadii = {
                  xRadius = windowCornerRadius,
                  yRadius = windowCornerRadius
              },
              compositeRule = "plusDarker"
          })
        end
        function a:showOverlay()
            self.canvas:topLeft({
                x = self.selected.frame.x,
                y = self.selected.frame.y
            }):size({
                w = self.selected.frame.w,
                h = self.selected.frame.h
            }):show()
        end
        function a:hideOverlay()
            self.canvas:hide()
        end
        return a
    end
}
return stackNavigateAction