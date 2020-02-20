--------------

-- when a quest is taken into account, have an init and a check to see if end

-- each quest can only be completed once

--------------


function init_quests()

  quest_board = {quest_chains = {}, selected_chains = {} }
  
  -- 3 available quests at all time
  
  -- something like 8 different quest chain

  -- have one that features redoable quests
  
  init_monstrology()
  init_feat()
  init_challenger()
  init_misc()
  
  quest_board.selected_chains = {1, 2, -1}
  
  -- init_feat()
                
                
  -- available_quests = {1, 2, 4}
  completed_quests = {}

end


function log_quest_status()
  for i, q in pairs(quests) do
    add_log(q.name .. " : " .. (q.collected and "Collected" or (is_in(i, available_quests) and ( q.check() and "Completed" or "Pending" ) or "Not Available")))
  end
end


function init_monstrology()
  
  local qc = { name = "monstrology", quests = {}, current = 1}
  
  add( qc.quests,  { 
                  name = "Monstrology I", 
                  desc = "Kill 20 enemies", 
                  prize = 100, 
                  check = function() return r_enemies_killed() >= 20 end , 
                  progress_bar = function() return min(20, r_enemies_killed()) / 20 end ,
                  progress_text = function() return min(20, r_enemies_killed()).."/".. 20 end , 
                  collected = false, 
                })
  add( qc.quests,  { 
                  name = "Monstrology II", 
                  desc = "Kill 50 enemies", 
                  prize = 200, 
                  check = function() return r_enemies_killed() >= 50 end , 
                  progress_bar = function() return min(50, r_enemies_killed()) / 50 end ,
                  progress_text = function() return min(50, r_enemies_killed()).."/".. 50 end , 
                })
  add( qc.quests,  { 
                  name = "Monstrology III", 
                  desc = "Kill 100 enemies", 
                  prize = 350, 
                  check = function() return r_enemies_killed() >= 100 end ,
                  progress_bar = function() return min(100, r_enemies_killed()) / 100 end ,
                  progress_text = function() return min(100, r_enemies_killed()).."/".. 100 end , 
                })
  add( qc.quests,  { 
                  name = "Monstrology IV", 
                  desc = "Kill 200 enemies", 
                  prize = 500,
                  check = function() return r_enemies_killed() >= 200 end ,
                  progress_bar = function() return min(200, r_enemies_killed()) / 200 end ,
                  progress_text = function() return min(200, r_enemies_killed()).."/".. 200 end , 
                })
                
  add(quest_board.quest_chains, copy_table(qc) )  
  
end

function init_feat()
  
  
  local qc = { name = "Feats", quests = {}, current = 1}
  
  add( qc.quests,  { 
                  name = "Newborn", 
                  desc = "Complete wave 1", 
                  prize = 50,
                  check = function() return best_wave_beaten >= 1 end , 
                  collected = false, 
                }) 
                
  add( qc.quests,  { 
                  name = "Toddler", 
                  desc = "Complete wave 2", 
                  prize = 75,
                  check = function() return best_wave_beaten >= 1 end , 
                  collected = false, 
                }) 
                
  add(quest_board.quest_chains, copy_table(qc) ) 
end

function init_challenger()
  
  
  local qc = { name = "Challenger", quests = {}, current = 1}
  
  add( qc.quests,  { 
                  name = "Challenger I", 
                  desc = "Play once", 
                  prize = 20,
                  check = function() return number_of_games >= 1 end , 
                  collected = false, 
                }) 
                
  add( qc.quests,  { 
                  name = "Challenger II", 
                  desc = "Play 5 times", 
                  prize = 60,
                  check = function() return number_of_games >= 5 end , 
                  collected = false, 
                }) 
                
  add(quest_board.quest_chains, copy_table(qc) ) 
end


function init_misc()
  
  
  local qc = { name = "Misc", quests = {}, current = 1}
  
  add( qc.quests,  { 
                  name = "Gotta go fast", 
                  desc = "Dash 100 times", 
                  prize = 80,
                  check = function() return dashed_through_projectiles >= 20 end , 
                  collected = false, 
                  progress_bar = function() return min(20, dashed_through_projectiles) / 20 end ,
                  progress_text = function() return min(20, dashed_through_projectiles).."/".. 20 end , 
                }) 
  add( qc.quests,  { 
                  name = "Anti-bullet time", 
                  desc = "Dash through 100 enemy projectiles", 
                  prize = 50,
                  check = function() return dashed_through_projectiles >= 20 end , 
                  collected = false, 
                  progress_bar = function() return min(20, dashed_through_projectiles) / 20 end ,
                  progress_text = function() return min(20, dashed_through_projectiles).."/".. 20 end , 
                }) 
                
  quest_board.quest_chains[-1] = copy_table(qc)
end


function redeem_prize(slot_index)
    
    local chain_index = quest_board.selected_chains[slot_index]
    
    local qc = quest_board.quest_chains[chain_index]
    local q = qc.quests[qc.current]
    
    player.coins = player.coins + q.prize
    q.collected = true
    
    -- the two top qc are quests from chain quests
    -- the 3rd is from a qc that has a lot of unrelated quests
    
    if chain_index ~= -1 then
      -- go to next quest
      qc.current = qc.current + 1
      
      -- if that was the last quest
      if not qc.quests[qc.current] then
        qc.current = -1 -- never touch this quest line again
      end
      
      -- replace this quest line with any qc except the misc one
      
      local pickable_quests = {}
      -- while not found or i > count(quest_board.quest_chains)
      for i, qc in pairs (quest_board.quest_chains) do
        if i ~= -1 and qc.quests[qc.current] and qc.current ~= -1 and not is_in(i,quest_board.selected_chains)  then
          add(pickable_quests, i)
        end
      end
      
      if count(pickable_quests) > 0 then 
        quest_board.selected_chains[slot_index] = pick(pickable_quests)
      end
      
      
    else
      -- take another quest that is not collected
      -- if possible, make "current" be a quest that is not collected in misc
      for i, q in pairs(qc.quests) do
        if not q.collected then qc.current = i end
      end
      
    end
  
end








