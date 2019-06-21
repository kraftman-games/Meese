

local game = {}
game.__index = game

-- needs to keep track of total scores
-- needs to switch games
-- needs a countdown for games

local levelsList = {
  Pong = require 'minigame.pong.pong',
  --Flappy = require 'minigame.flappy.flappy',
}

function game:AddLevels(numLevels)
  -- need to load random levels
  -- but not the same level more than once unless we run out
  -- get the levels we have the least off
  -- choose random from these
  -- always add scoreboard as end level
  local pong = levelsList.Pong:Create(self, self.players)
  table.insert(self.levels, pong)
end

function game:SetNextLevel(level)
  if self.currentLevel then
    self.meese:RemoveTarget(self.currentLevel)
  end
  if not self.levels[1] then 
    return nil
  end
  self.currentLevel = self.levels[1]
  self.meese:AddTarget(self.currentLevel)
  table.remove(self.levels, 1)
  return self.currentLevel
end

function game:EndLevel(scores)
  for id, score in pairs(scores) do
    self.scores[id] = self.scores[id] + score
  end
  local ok = self:SetNextLevel()
  if not ok then
    return self:FinishGame()
  end
end

function game:FinishGame()
  self.main:EndGame()
end

function game:Update(dt)
  self.currentLevel:Update(dt)
end

function game:Draw()
  self.currentLevel:Draw()
end

function game:Create(main, meese, players, numLevels)
  local defaults = {
    levels = {},
    scores = {},
    currentLevel,
    players = players,
    meese = meese,
    main = main
  }
  local ga = setmetatable(defaults, game)
  ga:AddLevels()
  for id, players in pairs(players) do
    ga.scores[id] = 0
  end
  ga:SetNextLevel()
  return ga
end


return game