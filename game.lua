

local game = {}
game.__index = game

-- needs to keep track of total scores
-- needs to switch games
-- needs a countdown for games

local levelsList = {
  Pong = require 'minigame.pong.pong',
  Flappy = require 'minigame.flappy',
}

function game:AddLevels(numLevels)
  -- need to load random levels
  -- but not the same level more than once unless we run out
  -- get the levels we have the least off
  -- choose random from these
  -- always add scoreboard as end level
end

function game:SetNextLevel(level)
  if not self.levels[i] then 
    return nil
  end
  self.currentLevel = self.levels[1]
  table.remove(self.levels, 1)
  return self.currentLevel
end

function game:FinishLevel(scores)
  for id, score in pairs(scores) do
    self.scores[id] = self.scores[id] + score
  end
  local ok = self:SetNextLevel()
  if not ok then
    return self:FinishGame()
  end
end

function game:FinishGame()
  main:EndGame()
end


function game:Create(main, players, numLevels)
  local defaults = {
    levels = {},
    scores = {},
    currentLevel
  }
  local ga = setmetatable(defaults, game)
  ga:AddLevels()
  for id, players in pairs(players) do
    ga.scores[id] = 0
  end
  return ga
end


return game