
e_template.skelly = { 
  name = "Skelly",
  id = "skelly",
  
  rarity = 1,
  w = 16,
  h = 16,
  s = 8*3,
  
  attributes = {
    hp = 10,
    maxspeed = 5,
    dmg = 1,
    recovery_time = .1,
    shooting_cd = .5, -- cooldown
    travel_d = 16*8,
    collide = true,
    y_sort = true,
    cadavreable = true,
  },
  
  init = function()
    local e_t = e_template.skelly
    local attributes = e_t.attributes
    
    local e = {
      id = e_t.id,
      hp = attributes.hp,
      speed = 0,
      buffs = {},
      ry = function(e) return e.y + 4 end,
      w = function (e) return get_t(e) and get_t(e).w end,
      h = function (e) return get_t(e) and get_t(e).h end,
    }
    
    e.x, e.y = get_init_position(e)
    
    e.d_per_sec = 25
    
    e.angle = atan2(player.x - e.x, player.y - e.y)
    e.last_hit = t() - get_a(e).recovery_time
       
    e.shooting_timer = 0    
    e.is_waiting = 0    
    
    return e
    
  end,
  
  update = function(e)
    
    if e.hp < 0 then kill_enemy(e) end
    
    if not e.spawned then move_enemy_in_pit(e) return end 
    
    local target = e.target
    
    if e.waiting_time and e.waiting_time > 0 then
      e.waiting_time = e.waiting_time - dt()
      
    elseif not e.target then
      -- e.can_spawn_pool = true
      e.target = {}
      local target = e.target
      
      
      if dist(player.x - e.x, player.y - e.y) > 16 * 5 then
        
        target.x = player.x + player.w/2
        target.y = player.y + player.h/2
      
      else
      
        local a = rnd(1)
        
        -- target.x = e.x + get_a(e).travel_d * (.75 + rnd(.5)) * cos(a)
        -- target.y = e.y + get_a(e).travel_d * (.75 + rnd(.5)) * sin(a)
        target.x = e.x + get_a(e).travel_d * (.75 + rnd(.5)) * cos(atan2(player.x - e.x, player.y - e.y) + .5)
        target.y = e.y + get_a(e).travel_d * (.75 + rnd(.5)) * sin(atan2(player.x - e.x, player.y - e.y) + .5)
        
      end
      
      e.moving_timer = 1 + rnd(.2)      
      e.angle = atan2(target.x - e.x, target.y - e.y)
      
      target.x = mid(world.x + 80, target.x, world.x + world.w - get_t(e).w - 80)
      target.y = mid(world.y + 80, target.y, world.y + world.h - get_t(e).h - 80)
      
    else
    
      e.moving_timer = e.moving_timer - dt()
      
      if dist(target.x - e.x, target.y - e.y) < 8 or e.moving_timer < 0 then 
        e.waiting_time = 1
        e.target = nil
      end
      
      e.x = e.x + cos(e.angle) * e.d_per_sec * dt()
      e.y = e.y + sin(e.angle) * e.d_per_sec * dt()
      
    end
    
    --world boundaries
      e.x = mid(world.x + 64, e.x, world.x + world.w - e:w() - 64)
      e.y = mid(world.y + 64, e.y, world.y + world.h - e:h() - 64)
    --
    
    e.shooting_timer = e.shooting_timer - dt()
    
    if e.shooting_timer < 0 then
      e.shooting_timer = get_a(e).shooting_cd * (.75 + rnd(.5))
      
      local proj = {}
      
      proj.type = "orb"
      
      proj.speed = 64 
      proj.dmg = 1
      proj.r =  5
      proj.c = _p_n("red")
      
      proj.life = 2 * (.90 + rnd(.20))
      
      proj.angle = atan2(player.x - e.x, player.y - e.y)
      
      local d = 14  
      proj.x = e.x + e:w()/2 + cos(proj.angle) * d
      proj.y = e.y + e:h()/2 + sin(proj.angle) * d 
      
      new_projectile("enemy", proj)
      
    end
    
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
    local s = flr(2*t()%2) 
    local fx = (a > -1/4 and a < 1/4)
    
    outlined( get_t(e).s + s, e.x, e.y, 1, 1, fx, flash and _p_n("white"))
    
    -- if e.target then
      -- outlined( get_t(e).s + s, e.target.x, e.target.y, 1, 1, fx, flash and _p_n("white"))
    -- end
  end,
  
  draw_shadow = function(e)
    spr( 2, e.x, e.y + 4)
  end,
  
}







