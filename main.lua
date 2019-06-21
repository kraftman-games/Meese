

local lg = love.graphics
local StartScreen = require 'startscreen'
local meese = require 'meese'
local Game = require 'game'

local main = {}
local startScreen = StartScreen:Create(main)
main.target = startScreen
meese:AddTarget(startScreen)

function main:EndGame()
  meese:RemoveTarget(self.target)
  self.target = startScreen
end

function main:StartGame()
  local players = meese:GetMice()
  local numLevels = 5
  local game = Game:Create(self, meese, players, numLevels)
  self.target = game
  meese:AddTarget(game)
end

function main:Pause()
  self.paused = true
  meese:RemoveTarget(self.target)
  meese:AddTarget(pauseMenu)

end

function main:Unpause()
  self.paused = false
  meese:RemoveTarget(pauseMenu)
  meese:AddTarget(self.target)
end

local game = {
  EndGame = function(self, playerScores)
    for k, v in pairs(playerScores) do
      print('id: ', k, 'score:', v)
    end
  end
}

love.mouse.setVisible(false)
love.mouse.setGrabbed(true)

function love.keypressed(key) 
  if(key == 'escape') then
    love.event.quit(0)
  end
end

function love.update(dt)
  if main.paused then
    pauseMenu:Update(dt)
  else
    main.target:Update(dt)
  end
end

function love.draw()
  meese:Draw()
  main.target:Draw()
  if main.paused then
    pauseMenu:Draw()
  end
  
end