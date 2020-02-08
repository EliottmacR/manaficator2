
function init_items()
  
  items = {}
  
  items.winged_boots = {
    name = "Winged boots", 
    
    desc = "What ? Yes, they belonged to Hermes!", 
    
    price = 10, 
    
    effect = function ()
      player.buffs.movement_speed = (player.buffs.movement_speed or 1) * 1.5
    end,
  }
  
  items.winged_crown = {
    name = "Winged crown", 
    
    desc = "Yes yes, this too.", 
    
    price = 10, 
    
    effect = function ()
      player.buffs.movement_speed = (player.buffs.movement_speed or 1) * 1.5
    end,
  }
  
  items.speed_pills = {
    name = "Speed pills", 
    
    desc = "Random but very fast pills.", 
    
    price = 10, 
      
    effect = function ()
      player.buffs.firing_speed = (player.firing_speed_buff or 1) * 1.5
      player.buffs.projectile_speed = (player.firing_speed_buff or 1) * 1.5
    end,
  }

end



function get_all_items()
  local i_n = {}
  for _, item in pairs(items) do add(i_n, item.name) end
  return i_n
end










