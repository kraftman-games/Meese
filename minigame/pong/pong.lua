
-- scores
-- ceiling/floor
-- collision between balls
-- coliision against paddles
-- end zones that increment scores
-- 

local HC = require 'libs.HC'
local lg = love.graphics

local pong = {}
pong.__index = pong


function pong:RemoveBall(ball)
  HC.remove(ball)
  self.balls[ball] = nil
end

function pong:EndLevel()
  local playerScores = {}
  local winningSide = self.scores.left > self.scores.right and 'left' or 'right'
  for id, paddle in pairs(self.paddles) do
    if paddle.side == winningSide then
      playerScores[id] = 1
    else
      playerScores[id] = 0
    end
  end
  return self.game:EndLevel(playerScores)
end

function pong:Score(zone)
  if zone == 'rightzone' then
    self.scores.left = self.scores.left + 1
  else 
    self.scores.right = self.scores.right + 1
  end
  self.scores.total = self.scores.total + 1
  if self.scores.total >= self.maxScore then
    return self:EndLevel()
  end
  self:AddBall()
  
end
function pong:RightScored()
  self.scores.right = self.scores.right + 1
  self.scores.total = self.scores.total + 1
  self:AddBall()

end

function pong:handleCollisions(ball)
  local collisions = HC.collisions(ball)
  local remove = false
  for other, vector in pairs(collisions) do
    if (other.type == 'wall') then
      ball:move(vector.x, vector.y)
      ball.vy = -ball.vy
    elseif other.type == 'leftzone' then
      remove = true
      self:Score(other.type)
    elseif other.type == 'rightzone' then
      remove = true
      self:Score(other.type)
    elseif other.type == 'paddle' then
      ball:move(vector.x, vector.y)
      ball.vx = -ball.vx
    elseif other.type == 'ball' then
      ball:move( vector.x/2,  vector.y/2)
      other:move(-vector.x/2, -vector.y/2)
      if vector.x < 0 then
        ball.vx = -math.abs( ball.vx )
      else
        ball.vx = math.abs( ball.vx )
      end
      if vector.y < 0 then
        ball.vy = -math.abs( ball.vy )
      else
        ball.vy = math.abs( ball.vy )
      end
    else
      print('oops: ', other.type)
    end
  end
  if remove then
    self:RemoveBall(ball)
  end
end

function pong:Update(dt)
  for k,ball in pairs(self.balls) do
    local newX = ball.x + ball.vx*dt
    local newY = ball.y + ball.vy*dt 
    ball:moveTo(newX, newY)
    self:handleCollisions(ball)
    ball.x, ball.y = ball:center()
  end



end

function pong:Draw()
  for k, v in pairs(self.paddles) do
    lg.setColor(255,255,255)
    lg.rectangle('fill', v.x, v.y, v.width, v.height)
  end
  for k, v in pairs(self.balls) do
    lg.setColor(255,255,255)
    lg.circle('fill', v.x, v.y, v.radius)
  end
  local sc= self.scores
  local text = 'left: '..sc.left..' right: '..sc.right
  lg.print(text, 200, 30)
end

function pong:MousePressed(id, button)

end

function pong:MouseReleased(id, button)

end

function pong:MouseMoved(id, x, y, relX, relY)
  local paddle = self.paddles[id]
  paddle:moveTo(paddle.x, y)
  paddle.y = y

end

function pong:AddWalls()
  local topLeft = 0, 0
  local w, h = lg.getDimensions()
  local topRight = w, 0
  local bottomLeft = 0, h
  local bottomRight = w,h
  local padding = 30
  local top = HC.rectangle(0, -padding, w, padding)
  top.type = 'wall'
  -- self.objects[top] = top

  local bottom = HC.rectangle(0, h, w, padding)
  bottom.type = 'wall'
  --self.objects[bottom] = bottom

  local leftzone = HC.rectangle(-padding, -padding, padding, padding*2+h)
  leftzone.type = 'leftzone'

  local rightzone = HC.rectangle(w, -padding, padding, padding*2+h)
  rightzone.type = 'rightzone'



end

function pong:SelectTeam()
  local i, j = 0, 0
  for k, v in pairs(self.paddles) do
    if v.side == 'left' then
      i = i + 1
    else
      j = j + 1
    end
  end
  return i > j and 'right' or 'left'
end

function pong:AddPlayers(players)
  for k,v in pairs(players) do
    -- work out where to assign the player
    local side = self:SelectTeam()
    local x = side == 'left' and 20 or self.width-20
    local y = self.height/2
    local width = 10
    local height = 30
    local paddle = HC.rectangle(x, y, width, height)
    paddle.side = side
    paddle.x = x
    paddle.y = y
    paddle.width = width
    paddle.height = height
    paddle.type = 'paddle'
    
    self.paddles[v.id] = paddle
  end
end

function pong:AddBall()
  
  local x = self.width/2
  local y = self.height/2
  local vx = 80
  local vy = 80
  local radius = 10
  local ball = HC.circle(x, y, radius)
  ball.x = x
  ball.y = y
  ball.vx = math.random(150, 300)
  ball.vy  = math.random(-130, 130)
  ball.radius = radius
  ball.type = 'ball'
  self.balls[ball] = ball

end

function pong:Create(game, players)
  local w, h = lg.getDimensions()
  local defaults = {
    paddles = {},
    balls = {},
    objects = {},
    width = w,
    height = h,
    scores = {left= 0, right= 0, total = 0},
    game = game,
    maxScore = 5
  }

  local pon = setmetatable(defaults, pong)
  pon:AddWalls()
  pon:AddPlayers(players)
  pon:AddBall()
  return pon
end

return pong