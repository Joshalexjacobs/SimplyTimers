-- [[ SimplyTimers created by Joshua Jacobs ]] --
-- [[              MIT License              ]] --
-- [[   Copyright (c) 2016 Joshua Jacobs    ]] --

local timer = {
  time = nil,
  label = nil
}

local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

local function findTimer(name, timerList)
  for i = 1, #timerList do
    if timerList[i].label == name then return i end
  end

  return 0 -- timer not found
end

-- need to build a fail safe for this, if timer already exists, fail timer creation
function addTimer(time, name, timerList)
  local newTimer = copy(timer, newTimer)
  newTimer.time, newTimer.label = time, name

  table.insert(timerList, newTimer)
end

function checkTimer(name, timerList)
  if #timerList <= 0 then return false end

  index = findTimer(name, timerList)
  if index == 0 then return false
  elseif timerList[index].label == name then
    return true
  end
end

function getTime(name, timerList)
  index = findTimer(name, timerList)
  if index ~= 0 and timerList[index].label == name then
    return timerList[index].time
  end
end

function resetTimer(time, name, timerList)
  timerList[findTimer(name, timerList)].time = time
end

function updateTimer(dt, name, timerList) -- update all existing timers
  if #timerList <= 0 then
    --print("no timers found")
    return false
  end -- if timerList does not contain any timers

  index = findTimer(name, timerList)

  if index == 0 then return false end

  if timerList[index].time <= 0 then
    return true
  elseif timerList[index].time > 0 then
    timerList[index].time = timerList[index].time - dt
    return false
  end
end

function deleteTimer(name, timerList)
  table.remove(timerList, findTimer(name, timerList))
end
