

local game = {}
game.__inex = game

-- needs to keep track of total scores
-- needs to switch games
-- needs a countdown for games


function game:AddLevels(numLevels)
  -- need to load random levels
  -- but not the same level more than once unless we run out
  -- get the levels we have the least off
  -- choose random from these
end

function game:SelectLevel(level)

end

function game:FinishLevel(scores)
 -- update scores
 -- if next game select next game
  -- if end shiow scoreboard
end


function game:Create(numLevels, players)
  local defaults = {
    levels = {}
  }
  self:AddLevels(numLevels)
end


return game