
local mouse = {}
local MAX_WIDTH, MAX_HEIGHT = love.graphics.getDimensions( )
local max, min = math.max, math.min
mouse.__index = mouse
local random = math.random

function mouse:GetX()
  return self.x
end
function mouse:GetY()
  return self.y
end

function mouse:isDown(button)
  return self.pressedButtons[button]
end

function mouse:GetCoords()
  return self.x, self.y, self.relX, self.relY
end

function mouse:UpdateX(relX)
  self.relX = relX
  self.x = self.x + relX
  self.x = min(self.x, MAX_WIDTH)
  self.x = max(self.x, 0)
end

function mouse:UpdateY(relY)
  self.relY = relY
  self.y = self.y + relY
  self.y = min(self.y, MAX_HEIGHT)
  self.y = max(self.y, 0)
end

function mouse:Create(id, x, y)
  local absX = MAX_WIDTH/2
  local absY = MAX_HEIGHT/2
  local defaults = {
    id = id,
    x = absX,
    y = absY,
    relX = x,
    relY = y,
    enabled = true,
    pressedButtons = {}
  }
  local m = setmetatable(defaults, mouse)
  return m
end

function mouse:PressButton(button)
  self.pressedButtons[button] = true
end

function mouse:ReleaseButton(button)
  self.pressedButtons[button] = false
end


local mice = {}

local meece = {}
meece.targets = {}

local function addMouse(id)
  if not mice[id] then
    mice[id] = mouse:Create(id)
  end
end

function love.micemoved(id, axis, value)
  id = id + 1
  addMouse(id)
  if axis == 'X' then
    mice[id]:UpdateX(value)
  else
    mice[id]:UpdateY(value)
  end
  
  for k,v in pairs(meece.targets) do
    if v.MouseMoved then 
      v:MouseMoved(id, mice[id]:GetCoords())
    end
  end
end

function love.micepressed(id, button)
  id = id + 1
  addMouse(id)
  mice[id]:PressButton(button)
  for k,v in pairs(meece.targets) do
    if v.MousePressed then 
      v:MousePressed(id, button)
    end
  end
end
function love.micereleased(id, button)
  id = id + 1
  addMouse(id)
  mice[id]:ReleaseButton(button)
  for k,v in pairs(meece.targets) do
    if v.MouseReleased then 
      v:MouseReleased(mice[id], button)
    end
  end
end


function meece:Draw()
  for k, v in pairs(mice) do
    love.graphics.setColor(0,255,0)
    love.graphics.circle('fill', v.x, v.y, 5)
  end
end

function meece:AddTarget(target)
  meece.targets[target] = target
end

function meece:RemoveTarget(target)
  meece.targets[target] = nil
end

function meece:GetNumMice()
  local i = 0
  for k,v in pairs(mice) do
    i = i +1
  end
  return i
end

function meece:GetMice()
  return mice
end
return meece



  -- add mice if it doesnt exist
  -- store mouse down/up
  -- lock mice to window edges
  -- hide main mouse