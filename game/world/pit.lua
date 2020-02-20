
function init_pit()

  world = {}
  
  world.x = 0
  world.y = 0
  
  world.w = 32*19
  world.h = 32*19

  if player then
    player.x = world.w/2 - player.w/2
    player.y = world.h/2 - player.h/2
  end
  
  init_waves()
  
  pit_bg = new_surface (world.w, world.h)
  
  target(pit_bg)
  
    draw_floor()
    draw_walls()
  
  target()
  
  name_world = "pit"
  
  send_signal("new_game")
  
end

function create_wave(enemies, spawn_delay)
  waves[1 + count(waves)] = {enemies = enemies, spawn_delay = spawn_delay}
end

function get_spawn_delay()
  return waves[current_wave] and waves[current_wave].spawn_delay or .6
end

function spawn_enemy()
  local choosen_type
  
  if pit_state == "in_wave" then
    choosen_type = get_random_type_left()
    if not choosen_type then return end 
    waves[current_wave].enemies[choosen_type].to_spawn = waves[current_wave].enemies[choosen_type].to_spawn - 1
  else
    choosen_type = get_rnd_enemy_type()
  end
  
  return new_enemy(choosen_type)
end

function get_random_type_left()
  
  if pit_state == "endless_wave" then return end
  
  local types = {}
  for i, e in pairs(waves[current_wave].enemies) do
    if e.to_spawn > 0 then add(types, e.type) end
  end
  
  return count(types) > 0 and pick(types)
end


----------------

BETWEEN_WAVE_TIME = 0


function init_waves()

  waves = {}
  
  create_wave(
    {
      zombie = { type = "zombie", to_spawn = 0, },
      acid_cloud = { type = "acid_cloud", to_spawn = 0, },
      skelly = { type = "skelly", to_spawn = 10, },
    },
    .6)
   
  current_wave = 0
  
  pit_state = "between_waves"
  b_w_timer = BETWEEN_WAVE_TIME
  spawn_timer = get_spawn_delay()
  
  area = {update = update_wave, draw = draw_pit, quit = quit_pit}
end

-----------------------

function update_wave()

  if pit_state == "in_wave" or pit_state == "endless_wave" then
    spawn_timer = spawn_timer - dt()
    
    if spawn_timer < 0 then
      
      if spawn_enemy() then 
        spawn_timer = get_spawn_delay()
      elseif pit_state == "in_wave" and count(enemies) < 1 then
        pit_state = "between_waves"
        b_w_timer = BETWEEN_WAVE_TIME
      end
    end
  elseif pit_state == "between_waves" then
    b_w_timer = b_w_timer - dt()
    if b_w_timer < 0 then
      current_wave = current_wave + 1
      
      if not waves[current_wave] then 
        pit_state = "endless_wave"
      else
        pit_state = "in_wave"
        spawn_timer = get_spawn_delay()
        begin_display_wave(current_wave)
      end
    end
  end
  
  
end


---------------------

function draw_pit()

  cls(_p_n("red"))
  spr_sheet (pit_bg, 0, 0)

end


function quit_pit()
  init_waves()
  
  remove_all_enemies()
  cadavres = {}
  time_began_display_wave = nil
  
  projectiles = {}
end







