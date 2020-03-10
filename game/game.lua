require("game/intro")
require("game/world/world")
require("game/player")
require("game/enemies/_enemies")
require("game/menus/_menus")
require("game/hud")
require("game/signals")
require("game/quests")
require("game/items")  

background_clr = 0

shader = [[
  extern vec2 distortionFactor;
  extern vec2 scaleFactor;
  extern number feather;
  vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px) {
  
    // to barrel coordinates
    uv = uv * 2.0 - vec2(1.0);
    
    // distort
    uv *= scaleFactor;
    uv += (uv.yx*uv.yx) * uv * (distortionFactor - 1.0);
    number mask = (1.0 - smoothstep(1.0-feather,1.0,abs(uv.x)))
                * (1.0 - smoothstep(1.0-feather,1.0,abs(uv.y)));
                
    // to cartesian coordinates
    uv = (uv + vec2(1.0)) / 2.0;
    return color * Texel_color(tex, uv) * mask;
  }
]]

shader_defaults = {
    distortionFactor = {1.06, 1.065},
    feather = 0.02,
    scaleFactor = {1, 1},
}
-- function init_shader()

-- end

function init_game()
  
  log_str = {}

  init_controls()
  init_fonts()

  init_palette()
  
  load_png("spr_sheet", "assets/spr_sheet.png", nil, true) 
  spritesheet_grid (16, 16)
  -- state = "intro"
  state = "game"
  
  
  init_world()
  init_items()
  init_player()
  
  cam = { x = 0, 
          y = 0}
          
  init_hud()
  
  init_signals()
  init_quests()
  
  init_intro()
  
  new_enemy("acid_cloud")
  for i = 1, 20 do send_signal( "is_dead", { e = pick(enemies) } ) end
  for i, e in pairs(enemies) do kill_enemy(e) end
  for i = 1, 20 do send_signal( "dashed_through_projectile") end 
  
  -- screen_shader(shader)
  screen_shader_input(shader_defaults)
  
end

function update_game()
  
  timer_intro = timer_intro - dt()
  screen_shader_input({
    distortionFactor = {1.06, 1.065},
    feather = 0.04,
    scaleFactor = {1, 1},
})
  
  if state == "intro" then
    update_intro()
    return
  end
  
  if btnp("n") then init_start_area() end
  
  update_world()
  
  update_enemies()
  update_player()
  update_projectiles()
  update_camera()
  
  update_hud()
  
  if write_ and count(write_) > 0 then for i, str in pairs(write_) do add_log(i .. ":" .. str) end end
  
end

function get_player_mov_angle()
  return atan2(player.v.x, player.v.y)
end

function update_camera()
  local angle = get_player_mov_angle()
  local mdist = 16
  
  local xoffset = cos(angle) * mdist * abs(player.v.x)/get_player_max_speed()
  local yoffset = sin(angle) * mdist * abs(player.v.y)/get_player_max_speed()
  
  cam.x = player.x + player.w/2 - GW/2 + xoffset
  cam.y = player.y + player.h/2 - GH/2 + yoffset
end

function draw_game()
  
  if state == "intro" then
    cls(_p_n("black"))
    draw_intro()      
  else
    cls(background_clr)
    
    camera(cam.x, cam.y)
      draw_world()
      draw_projectiles()
      draw_shadows()
      y_sort_draw() 
      if area.post_draw then area.post_draw() end
      draw_cursor()
    camera()
    
    draw_hud()
  end
  
  draw_mouse()
  use_font("16")
  print_log()
  
end

function draw_shadows()
  draw_shadow_player()
  draw_shadow_enemies()
end

function draw_mouse()
  outlined( 4, btnv("mouse_x") - 8, btnv("mouse_y") - 8)
end

function init_controls()
  -- register_btn(0, 0, input_id("mouse_button", "lb"))
  -- register_btn(1, 0, input_id("mouse_button", "rb"))
  -- register_btn(2, 0, input_id("mouse_position", "x"))
  -- register_btn(3, 0, input_id("mouse_position", "y"))
  
  
  register_btn("up",    0, {input_id("keyboard", "z"), input_id("keyboard", "w")}) 
  register_btn("left",  0, {input_id("keyboard", "q"), input_id("keyboard", "a")}) 
  register_btn("down",  0,  input_id("keyboard", "s"))
  register_btn("right", 0,  input_id("keyboard", "d"))
  
  
  register_btn("space", 0,  input_id("keyboard", "space"))
  register_btn("quest", 0,  input_id("keyboard", "k"))
  
  register_btn("g", 0,  input_id("keyboard", "g"))
  register_btn("j", 0,  input_id("keyboard", "j"))
  register_btn("y", 0,  input_id("keyboard", "y"))
  register_btn("p", 0,  input_id("keyboard", "p"))
  register_btn("h", 0,  input_id("keyboard", "h"))
  register_btn("n", 0,  input_id("keyboard", "n"))
  
  register_btn("shoot" , 0, {input_id("mouse_button", "lb"),  input_id("mouse_button", "rb")})
  register_btn("select", 0,  input_id("mouse_button", "lb"))
  register_btn("back"  , 0,  input_id("mouse_button", "rb"))
  
  register_btn("mouse_x", 0, input_id("mouse_position", "x"))
  register_btn("mouse_y", 0, input_id("mouse_position", "y"))
  

end

function init_fonts()
  
  load_font("sugarcoat/TeapotPro.ttf", 48, "48", false)
  load_font("sugarcoat/TeapotPro.ttf", 32, "32", false)
  load_font("sugarcoat/TeapotPro.ttf", 24, "24", true)
  load_font("sugarcoat/TeapotPro.ttf", 16, "16", true)
  
end


function load_user_info()
  network.async(  
    function () 
      user = castle.user.getMe()
      my_id   = user.userId
      my_name = user.name or user.username
    end)
end
  

