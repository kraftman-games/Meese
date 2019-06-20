

local lg = love.graphics

local Pong = require 'minigame.pong.pong'
local players = {
  [1] = {id = 0},
  [2] = {id = 1},
  [3] = { id = 3},
}

local game = {
  EndGame = function(self, playerScores)
    for k, v in pairs(playerScores) do
      print('id: ', k, 'score:', v)
    end
  end
}
local pong = Pong:Create(game, players)
local meese = require 'meese'
meese:AddTarget(pong)

love.mouse.setVisible(false)
love.mouse.setGrabbed(true)

function love.keypressed(key) 
  if(key == 'escape') then
    love.event.quit(0)
  end
end

function love.update(dt)
  pong:Update(dt)
end

function love.draw()
  meese:Draw()
  pong:Draw()
  
end