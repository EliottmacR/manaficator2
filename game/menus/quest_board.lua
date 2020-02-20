  
function init_qb_menu()

  qb_w = { }
  
  qb_w.w = GW * 3/4
  qb_w.h = GH * 2/3
  
  qb_w.x = GW/2 - qb_w.w/2
  qb_w.y = GH/2 - qb_w.h/2
  
  qb_w.bw = qb_w.w
  qb_w.bh = qb_w.h/3

end

function init_qb(from_qb)
  init_qb_menu()
  qb_surf = qb_surf or new_surface(qb_w.w+1, qb_w.h+1, "qb_main")
  opened_from_qb = from_qb
end

function show_qb(from_qb)
  close_other_menus()
  SHOWING_QB = true
  
  init_qb(from_qb)
  
end

function close_qb()
  SHOWING_QB = false
end

function update_qb()
  
  local s = qb_w
  -- add_log("opened_from_qb : " .. (opened_from_qb and "true" or "false"))
  
  if (btnr("select") and point_in_rect(btnv("mouse_x"), btnv("mouse_y"), s.x + s.w + 8, s.y - 20, 16, 16)) or btnr("back") then
    close_qb()
  end
  
end

function draw_qb()

  local s = qb_w
  
  -- TITLE
    use_font("32")
    c_cool_print("Quest Board", GW/2, GH/12 + sin(t() / 3) * 5)
  --
  
  -- CLOSING ZONE
    rctf(s.x + s.w + 8, s.y - 20, 16, 16, _p_n("red"))
  --
  
  target(qb_surf)
  
  local y = 0
  
  for i = 1, 3 do
    
    local qc = quest_board.quest_chains[quest_board.selected_chains[i]]
    
    rctf(0, y, s.bw, s.bh, _p_n("pink"))
    rctf(3, y + 3, s.bw - 6, s.bh - 6, _p_n("black"))
    
    local q = qc.quests[qc.current]
    
    if q then     
    
    local name = q and q.name or ""
    local desc = q and q.desc or ""
      
      use_font("16")
      c_cool_print(name, s.bw/2, y + 10)
      
      
      use_font("24")
      use_font(str_width(desc) > s.bw and "16" or "24")
        
      c_cool_print(desc, s.bw/2, y + s.bh/2 - str_height(desc)/2)
      
      if q.check() and not q.collected then 
        if btnp("select") then
          if mouse_in_rect(3, y + 3, 3 + s.bw - 6, y + 3 + s.bh - 6, btnv("mouse_x") - s.x, btnv("mouse_y") - s.y) then        
            redeem_prize(i)
          end
        end
      end
      
      -- progress bar : 
      if not opened_from_qb or not q.check() then
        if q.progress_bar then
          local ratio = q.progress_bar()
          local text = q.progress_text()
          rctf(3, y + s.bh - s.bh/4 - 3, s.bw - 6, s.bh/4, _p_n("yellow"))
          rctf(6, y + s.bh - s.bh/4, s.bw - 12, s.bh/4 - 6, _p_n("red"))
          if ratio > 0 then
            rctf(6, y + s.bh - s.bh/4, (s.bw - 12) * ratio, s.bh/4 - 6, _p_n("green"))
          end
          if text then
            use_font("16")
            c_cool_print(text, s.bw/2, y + s.bh - s.bh/4 + 5)
          end
        else
          use_font("16")
          local str = (q.check() and "C" or "Not c") .. "ompleted"
          c_cool_print(str, s.bw/2, y + s.bh - s.bh/4 + 5)
        end
      else
        if q.check() then
          
          use_font("16")
          
          if q.collected then
            local str = "Reward Collected"
            c_cool_print(str, s.bw/2, y + s.bh - s.bh/4 + 5, _p_n("black"), _p_n("yellow") )
          else
            local str = "Click to collect"
            c_cool_print(str, s.bw/2, y + s.bh - s.bh/4 + 5, _p_n("black"), _p_n(flr(t() * 3) % 2 == 0 and "yellow" or "pink" ) )
          end
          
        else
          use_font("16")
          local str = "Not completed"
          c_cool_print(str, s.bw/2, y + s.bh - s.bh/4 + 5)
        end
      end
    end

    y = y + s.bh
  end
  
  target()
  spr_sheet(qb_surf, s.x, s.y)
end