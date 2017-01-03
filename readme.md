# SimplyTimers.lua

An easy to use timer library created for the Love2D framework.

## API

### Require SimplyTimers

``` lua
require "SimplyTimers"
```

### Creating a new timer

``` lua
addTimer(time, name, timerList)
```

The addTimer function asks for a time (in seconds), a name (string), and a timerList (a list of timers).

#### Time
Time is passed in seconds and NOT milliseconds, but will take fractions of a second.

``` lua
-- 500 milliseconds
addTimer(0.5, name, timerList)

-- 100 milliseconds
addTimer(0.1, name, timerList)

-- 2 seconds
addTimer(2.0, name, timerList)
```

#### Name
The Name parameter is stored with the timer and acts as a label. Whenever you want to access that timer again you need to use it's name to call it.

``` lua
-- add a timer with the name "shoot"
addTimer(0.7, "shoot", timerList)

-- check if the shoot timer is finished
if updateTimer(dt, "shoot", timerList) then
  -- ...
end
```

#### TimerList
The timerList is where your timers will be stored. There's no limit to how many different timerLists you may have and how many timers are in each list.
This means that each and every entity in our game can have their own timerList.

This way we don't have to update every single timer created every tick. We only have to update the timers that are currently being used by active entities.

``` lua
if entity.isDead and checkTimer("dead", entity.timers) == false then
  addTimer(0.6, "dead", entity.timers)
  -- play death animation
end
```

### Updating a timer

``` lua
updateTimer(dt, name, timerList)
```

The updateTimer function either returns TRUE or FALSE. If the return value is false, then the timer has yet to hit 0. If the return value is true, then the timer we're updating has just reached 0 and is complete.

``` lua
if updateTimer(dt, "dead", entity.timers) then
  -- our death animation has finished
  deleteTimer("dead", entity.timers)
end
```

### Deleting a timer

``` lua
deleteTimer(name, timerList)
```

Deleting a timer only requires the timer's name and the list it's stored in. This removes the timer from the timerList which allows us to reuse it's name for a future timer.

``` lua
deleteTimer("shoot", entity.timers)
```

### Reseting a timer

``` lua
resetTimer(time, name, timerList)
```

Reseting a timer is almost identical to adding a timer.

``` lua
resetTimer(0.2, "shoot", entity.timers)
```

### Get a timer's time

``` lua
getTime(name, timerList)
```

If needed, you can access a timer's current time. The return value will be in seconds.

``` lua
getTime("follow", entity.timers)
```

### Check if a timer exists

``` lua
checkTimer(name, timerList)
```

If you need to check whether a timer exists in the given timerList you can us the checkTimer function.

``` lua
if checkTimer("chase", entity.timers) == false then
  addTimer(1.5, "chase", entity.timers)
end
```

## Examples
### Some examples of where SimplyTimers.lua can be used:

####The main.lua file in this git repo:
``` lua
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
```

####An enemy update function:
``` lua
behaviour = function(dt, entity, world)
  if entity.isDead == false then
    local angle = math.atan2(entity.y - player.y, entity.x - player.x)
    entity.dx = -math.cos(angle) * dt * entity.speed
    entity.dy = -math.sin(angle) * dt * entity.speed

    if entity.hp <= 0 then
      entity.isDead = true
    end

  elseif entity.isDead and checkTimer("dead", entity.timers) == false then
    addTimer(0.6, "dead", entity.timers)
    entity.explode:play()
    entity.curAnim = 2
  end

  if updateTimer(dt, "dead", entity.timers) then
    entity.playDead = true
  end
end,
```

####Part of an enemy bullets update function:
``` lua
function updateEBullets(dt, world)
  for i, newEBullet in ipairs(eBullets) do
    -- ...

    if updateTimer(dt, "life", newEBullet.timers) then
      newEBullet.isDead = true
      if world:hasItem(newEBullet) then removeEBullet(newEBullet, i, world) end
    end

    if newEBullet.isDead == true then
      if checkTimer("life", newEBullet.timers) then
        deleteTimer("life", newEBullet.timers)
      end

      newEBullet.curAnim = 2
      newEBullet.type = "dead"

      if checkTimer("dead", newEBullet.timers) == false then
        addTimer(0.4, "dead", newEBullet.timers)
      end

      if updateTimer(dt, "dead", newEBullet.timers) then
        newEBullet.playDead = true
      end
    end
  end
end
```
