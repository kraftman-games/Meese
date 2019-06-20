-- mvp:
-- object per player
-- barriers with specific distance between them
-- way to scale dificulty accurately

-- extra
-- theme matching rest of game

local flappy = {}
flappy.__index = flappy

function flappy:Update(dt)
  -- for each bird
  -- if flying then 
  --   increase vx
  -- if collision then
  --   kill

  -- for each barrier
  -- update vx 

end

function flappy:Draw()

end

function flappy:MousePressed(id, button)
  -- find bird
  -- set flying
end

function flappy:MouseReleased(id, button)
  -- find bird
  -- set not flying
end

function flappy:MouseMoved(id, x, y, relX, relY)

end

function flappy:Create(game, players)
  local defaults = {
    birds = {},
    blocks = {}
  }
  local flap = setmetatable(defaults, flappy)

  return flap
end

return flappy