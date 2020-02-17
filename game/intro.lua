require("game/world/world")
require("game/player")
require("game/enemies/_enemies")
require("game/menus/_menus")
require("game/hud")
require("game/signals")
require("game/quests")
require("game/items") 

function init_intro()
  
  time_intro = nb_slide * slide_dur + (nb_slide-1) * waiting_time
  timer_intro = time_intro
  
  
  
  -- stars
  clouds = {}
  for i = 1, 20 do
    
    local c = {cs = {{}} }
    
    c.speed = - 15 + irnd(30)
    
    c.cs[1].x = irnd(GW)
    c.cs[1].y = irnd(GH)
    c.cs[1].r = irnd(16) + 16
    
    
    for i = 2, 7 + irnd(15) do
      c.cs[i] = {}
      local p = 1 + irnd(count(c.cs)-1)
      c.cs[i].x = c.cs[p].x + irnd(c.cs[p].r)*1.5 - c.cs[p].r/1.5
      c.cs[i].y = c.cs[p].y + irnd(c.cs[p].r)*1.5 - c.cs[p].r/1.5
      c.cs[i].r = irnd(16) + 16
      
      -- c[i].o = 1 - irnd(2) * -1
      
    end
    
    add(clouds, c)
  end
  
  
end

function update_intro()
  
  for i, cloud in pairs(clouds) do
    for j, c in pairs(cloud.cs) do
      c.x = c.x + cloud.speed * dt()
    end    
  end
  
  if btnp("p") then timer_intro = 0 end
   
end


waiting_time = 1
slide_dur = 2
nb_slide = 4

function draw_intro()

  cls(_p_n("bbrown"))      
  
  draw_background_intro()
  
  if show_manaficator then
    
    use_font("64")
    c_cool_print("Manaficator II", GW/2, GH/2, _p_n("brick_red"),  _p_n("black")) 
  
  else
  
    if timer_intro >= 0 then
      col_card = _p_n("orange")
      
      use_font("16")
      
      local step
            
      if     timer_intro > time_intro - slide_dur then -- print
        step = 1
      elseif timer_intro > time_intro - slide_dur   - waiting_time   then -- change
        step = 2
      elseif timer_intro > time_intro - slide_dur*2 - waiting_time   then  -- print 
        step = 3
      elseif timer_intro > time_intro - slide_dur*2 - waiting_time*2 then  -- change
        step = 4
      elseif timer_intro > time_intro - slide_dur*3 - waiting_time*2 then  -- print
        step = 5
      elseif timer_intro > time_intro - slide_dur*3 - waiting_time*3 then  -- change
        step = 6
      end
      
      if step == 1 then
        local str = "eliott"
        intro_print(str)
      elseif step == 2 then
        
        local w = GW
        local h = 32
        local x = 0
        local r = 1 - reduce(time_intro - slide_dur, time_intro - slide_dur - waiting_time, timer_intro)
        local y = GH - sin(r) * h
        local str = r < .25 and "eliott" or "with the help of XXX and XXX"
        
        intro_print(str)
        rctf(x, y, w, h, col_card )
        
      elseif step == 3 then
        local str = "with the help of XXX and XXX"
        intro_print(str)
      elseif step == 4 then
      
        local w = GW
        local h = 32
        local x = 0
        local r = 1 - reduce(time_intro - slide_dur*2 - waiting_time, time_intro - slide_dur*2 - waiting_time*2, timer_intro)
        local y = GH - sin(r) * h
        local str = r > .25 and "presents" or "with the help of XXX and XXX"
        
        intro_print(str)
        rctf(x, y, w, h, col_card )
        
        
        
      elseif step == 5 then
      
        local str = "presents"
        intro_print(str)
        
      elseif step == 6 then
      
        local w = GW
        local h = 32
        local x = 0
        local r = 1 - reduce(time_intro - slide_dur*3 - waiting_time*2, time_intro - slide_dur*3 - waiting_time*3, timer_intro)        
        local y = GH - sin(r) * h
        local str = r < .25 and "presents" or ""
        
        intro_print(str)
        rctf(x, y, w, h, col_card )
      else
        
        show_manaficator = true
        
        
      end
    end
  end
end

function draw_background_intro()
  
  for i, cloud in pairs(clouds) do
    for j, c in pairs(cloud.cs) do
      circfill(c.x, c.y, c.r, _p_n("white"))
    end    
  end
   
  
end