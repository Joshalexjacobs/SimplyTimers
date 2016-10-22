-- main.lua

require "SimplyTimers"

local index = 1
local remaining = 0.0
local max = 0
local timers = {}

function love:keypressed(key, code)
  if checkTimer("start", timers) == false then
    if key == "space" or key == "return" then
      addTimer(remaining, "start", timers)
      max = remaining
    end
  end

  if key == "escape" then
    love.event.quit()
  end

  if checkTimer("start", timers) == false and remaining < 10 then
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
  smallestFont = love.graphics.newFont("kenpixel_mini.ttf", 15)
  smallFont = love.graphics.newFont("kenpixel_mini.ttf", 20)
  bigFont = love.graphics.newFont("kenpixel_mini.ttf", 40)
  love.graphics.setFont(bigFont)
end

function love.update(dt)
  if updateTimer(dt, "start", timers) then
    deleteTimer("start", timers)
    remaining = 0
  end
end

function love.draw()
  love.graphics.printf("Simply Timers", 0, 50, 800, "center")
  love.graphics.printf( string.format("%.2f", tostring(remaining)), 350, 150, 500 )

  if checkTimer("start", timers) then
    love.graphics.printf("Timer Active", 0, 400, 800, "center")
    love.graphics.setColor(100, 0, 0, 255)
    love.graphics.rectangle("fill", 106, 206, remaining/max * 587, 19)
    love.graphics.setColor(255, 255, 255, 255)
    remaining = getTime("start", timers)
  else
    love.graphics.printf("Timer Inactive", 0, 400, 800, "center")
  end

  love.graphics.setFont(smallFont)
  love.graphics.printf(string.format("%.2f" , tostring(max)), 640, 180, 200)
  love.graphics.setFont(smallestFont)
  love.graphics.printf("Use 0-9 to set the timer\nPress Space/Enter to start", 5, 5, 800, "left")
  love.graphics.setFont(bigFont)

  love.graphics.rectangle("line", 106, 206, 587, 19)
end
