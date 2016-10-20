-- main.lua

require "SimplyTimers"

local index = 1
local remaining = 0.0
local timers = {}

function love:keypressed(key, code)
  if checkTimer("start", timers) == false then
    if key == "space" or key == "return" then
      addTimer(remaining, "start", timers)
    end
  end

  if key == "escape" then
    love.event.quit()
  end

  if checkTimer("start", timers) == false then
    if key == "1" then
      remaining = remaining * 10 + 0.01
    elseif key == "2" then
      remaining = remaining * 10 + 0.02
    elseif key == "3" then
      remaining = remaining * 10 + 0.03
    elseif key == "4" then
      remaining = remaining * 10 + 0.04
    elseif key == "5" then
      remaining = remaining * 10 + 0.05
    elseif key == "6" then
      remaining = remaining * 10 + 0.06
    elseif key == "7" then
      remaining = remaining * 10 + 0.07
    elseif key == "8" then
      remaining = remaining * 10 + 0.08
    elseif key == "9" then
      remaining = remaining * 10 + 0.09
    elseif key == "0" then
      remaining = remaining * 10 + 0.00
    end
  end
end

function love.load(arg)

end

function love.update(dt)
  if updateTimer(dt, "start", timers) then
    deleteTimer("start", timers)
    remaining = 0
  end
end

function love.draw()
  love.graphics.printf( string.format("%.2f", tostring(remaining)), 360, 350, 100 )

  if checkTimer("start", timers) then
    love.graphics.printf("Start Timer Active", 300, 400, 200)
    remaining = getTime("start", timers)
  else
    love.graphics.printf("Start Timer Inactive", 300, 400, 200)
  end
end
