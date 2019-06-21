

-- start game
-- settings
-- quit
local lg = love.graphics

local start = {}
start.__index = start

function start:Draw()
  for k, v in pairs(self.buttons) do
    lg.setColor(255,255,255)
    lg.rectangle('line', v.x, v.y, v.width, v.height)
    lg.print(v.label, v.x+10, v.y)
  end
end

function start:MouseReleased(mouse, button)
  local x, y = mouse:GetCoords()
  print(x, y)
  for k,v in pairs(self.buttons) do
    print(v.x, v.y)
    if x > v.x and x < v.x + v.width 
      and y > v.y and y < v.y+v.height then
        v:OnClick()
    end
  end
end

function start:Update(dt)

end

function start:AddButtons()
  local x, y = lg.getDimensions()
  local startGame = {
    x = x/2,
    y = y/2,
    width = 70,
    height = 20,
    label = 'Start',
    OnClick = function()
      self.main:StartGame()
    end
  }
  local quitGame = {
    x = x/2,
    y = y/2 + 40,
    width = 70,
    height = 20,
    label = 'Quit',
    OnClick = function() love.event.quit() end
  }

  self.buttons[startGame] = startGame
  self.buttons[quitGame] = quitGame


end
function start:Create(main)
  local defaults = {
    main = main,
    buttons = {}
  }
  local sta = setmetatable(defaults, start)

  sta:AddButtons()
  return sta
end


return start