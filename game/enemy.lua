
enemies = {}
eid = 0
function new_enemy(e_type)
  if not e_template[e_type] then return end
  
  local e_t = e_template[e_type]
 
  local e = e_t.init()
  eid = eid + 1
  
  e.eid = eid
  enemies[e.eid] = e
  return e
end

function update_enemies()
  for _, e in pairs(enemies) do e_template[e.id].update(e) end
end

function draw_enemies()
  for _, e in pairs(enemies) do e_template[e.id].draw(e) end
end


----------------------------------------


function get_init_position(e)

  local way = irnd(4)
  local x, y
  
  if way == 0 then
  
    -- top
    y = - get_t(e).h - irnd(16)
    x = irnd(world.w)
  elseif way == 1 then
  
    -- right
    x = world.w + irnd(16)
    y = irnd(world.h)
  
  elseif way == 2 then
  
    -- bottom
    y = world.h + irnd(16)
    x = irnd(world.w)
  
  else -- way == 3
  
    -- left
    x = irnd(get_t(e).w)
    y = irnd(world.h)
  end
  return x, y
end

function get_t(e)
  return e_template[e.id]
end

function get_a(e)
  return get_t(e).attributes
end

function move_enemy_in_pit(e)
  
  local w = get_t(e).w
  local h = get_t(e).h
  
  if e.x > world.w - w - 64 then
    e.x = e.x - irnd(43) * dt()
  elseif e.x < 64 then
    e.x = e.x + irnd(43) * dt()
  end
  
  if e.y > world.h - h - 64  then
    e.y = e.y - irnd(43) * dt()
  elseif e.y < 64 then
    e.y = e.y + irnd(43) * dt()
  end
  
  if is_in_pit(e) then
    e.spawned = true
  end
  
end

function hit_ennemy(e, dmg)
  if get_t(e).hit then get_t(e).hit(e, dmg) end 
end

function is_in_pit(e)
  return e.x > 64 and e.x < world.w - get_t(e).w - 64 and e.y > 64 and e.y < world.h - get_t(e).h - 64
end


e_template = {}
  
do -- find all the wands

  files = love.filesystem.getDirectoryItems( "game/enemies/" )

  for k, file in ipairs(files) do
    if file ~= "_enemies.lua" then
      file = file:sub( 1, #file - 4 )
      require("game/enemies/"..file)
    end
  end
  
end

--[[
e_template.enemy1 = { 
  name = "enemy1",
  id = "enemy1",
  
  w = 16,
  h = 16,
  
  attributes = {
    hp = 10,
    maxspeed = 5,
    dmg = 1,
    recovery_time = .1,
  },
  
  init = function()
    local e_t = e_template.enemy1
    local attributes = e_t.attributes
    
    local e = {
      id = e_t.id,
      hp = attributes.hp,
      speed = 0,
      buffs = {},
    }
    
    -- e.x = world.x + irnd(world.w-e_t.w)
    -- e.y = world.y + irnd(world.h-e_t.h)
    
    e.x, e.y = get_init_position(e)
    
    e.d_per_sec = 100
    
    e.angle = atan2(player.x - e.x, player.y - e.y)
    e.last_hit = t() - get_a(e).recovery_time
    
    return e
    
  end,
  
  update = function(e)
    
    if not e.spawned then move_enemy_in_pit(e) return end 
    
    -- every frame, get closer from the player
    
    if e.hp < 0 then enemies[e.eid] = nil end
    
    local target = player
    
    local distance = dist(target.x, target.y, e.x, e.y) 
    
    if e.old_target then
      target = e.old_target
      distance = max(dist(target.x, target.y, e.x, e.y) , distance)
    end
    
    if distance > 60 then  
      e.angle = atan2(target.x - e.x, target.y - e.y)
      e.old_target = nil
    else
      if not e.old_target then
        e.old_target = {x = player.x, y = player.y}
      end
    end
    
    e.x = e.x + cos(e.angle) * e.d_per_sec * dt()
    e.y = e.y + sin(e.angle) * e.d_per_sec * dt()
    
    local acc = dt() * 10 * 5
    -- local destroyable = collide_objgroup(s,"destroyable")
    local enemy = collide_objgroup(e,enemies)
    if enemy then 
      e.x = e.x + sgn(e.x - enemy.x) * acc * 0.5
      e.y = e.y + sgn(e.y - enemy.y) * acc * 0.5
    end
    
    
    
    --world boundaries
      e.x = mid(world.x + 64, e.x, world.x + world.w - get_t(e).w - 64)
      e.y = mid(world.y + 64, e.y, world.y + world.h - get_t(e).h - 64)
    --
    
  end,
  
  hit = function(e, dmg)
    if e.last_hit + get_a(e).recovery_time < t() then
      e.last_hit = t()
      e.hp = e.hp - (dmg or 0)
      
    end
  end,
  
  draw = function(e)
    local flash = (e.last_hit + get_a(e).recovery_time > t())
    local a = e.angle
    local s = flr(t()%2) 
    local fx = (a > -1/4 and a < 1/4)
    -- spr( 2, e.x, e.y + 4)
    outlined( 8*2 + s, e.x, e.y, 1, 1, fx, flash and _p_n("white"))
  end,
  
}

--]]







