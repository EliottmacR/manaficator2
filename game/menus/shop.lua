  
function init_shop_menu()

  shop_w = { }
  
  shop_w.w = GW * 3/4
  shop_w.h = GH * 2/3
  
  shop_w.x = GW/2 - shop_w.w/2
  shop_w.y = GH/2 - shop_w.h/2
  
  shop_w.choosen = 1
  shop_w.index = 1

  shop_w.cw = 50
  shop_w.ch = shop_w.h/4
  
  shop_w.rw = 16
  shop_w.rh = 16*3
  
  
  
  buy_b = {}
  
  buy_b.buy_text    = "Buy"
  buy_b.bought_text = "Bought"
  
  use_font("32")
  
  buy_b.w    = str_width(buy_b.buy_text) * 1.8
  buy_b.h    = str_height(buy_b.buy_text) * 2.5
  
  buy_b.x    = GW/2
  buy_b.y    = shop_w.y + shop_w.h + 16
  buy_b.c    = {_p_n("yellow"), _p_n("black"),_p_n("gray"), _p_n("black")}
  
  buy_b.rx    = GW/2 - str_width(buy_b.buy_text)/2
  buy_b.ry    = shop_w.y + shop_w.h + 16 - str_height(buy_b.buy_text)/3
  
end

function init_shop()
  init_shop_menu()
  shop_surf = shop_surf or new_surface(shop_w.w+1, shop_w.h+1, "shop_main")
  
  if not items_on_sale then
    items_on_sale = {{}, {}}
    
    I_O_S_CATEGORIES = { "Wands", "Accessories"}
    
    for i, w in pairs(wands) do 
      add(items_on_sale[1], i)
    end
    
    for i, it in pairs(items) do 
      add(items_on_sale[2], i)
    end  
    
  end
  
end

function show_shop()
  close_other_menus()
  SHOWING_SHOP = true
  
  init_shop()
  
end


function get_target_tab_shop(ind)
  return ind == 1 and wands or ind == 2 and items
end

function close_shop()
  SHOWING_SHOP = false
end

function update_shop()
  
  local s = shop_w
  
  if (btnr("select") and point_in_rect(btnv("mouse_x"), btnv("mouse_y"), s.x + s.w + 8, s.y - 20, 16, 16)) or btnr("back") then
    close_shop()
  end
  
  -- ARROWS
  
    -- left
      hover_l = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, 10, s.h/2 - s.rh/2 - s.ch/4, s.rw, s.rh)
      if (btnp("select") and hover_l) then
        s.index = max(s.index - 1, 1) 
      end
    --
    
    -- right
      hover_r = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, s.w - s.rw - 10, s.h/2 - s.rh/2 - s.ch/4, s.rw, s.rh)
      if (btnp("select") and hover_r) then 
        s.index = min(s.index + 1, count(items_on_sale[s.choosen])) 
      end
    --
  --
  
  -- CATEGORIES
  
    if s.choosen == 1 then
      hover_l_c = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, 0, s.h - s.ch, s.w/2, s.ch)
    else
      hover_l_c = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, 0, s.h - s.ch * 3/4, s.w/2, s.ch * 3/4)
      if (btnp("select") and hover_l_c) then s.choosen, s.index = 1, 1 end
    end
    
      
    if s.choosen == 1 then
      hover_r_c = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, s.w/2, s.h - s.ch * 3/4, s.w/2, s.ch * 3/4)
      if (btnp("select") and hover_r_c) then s.choosen, s.index = 2, 1 end
    else
      hover_r_c = point_in_rect(btnv("mouse_x") - s.x, btnv("mouse_y") - s.y, s.w/2, s.h - s.ch, s.w/2, s.ch)
    end
    
  --  
  
  buy_b.can_buy = player.coins > current_item_displayed().price
  
  if buy_b.can_buy and not current_item_displayed().bought then
    
    buy_b.hovered = point_in_rect(btnv("mouse_x"), btnv("mouse_y"), buy_b.rx, buy_b.ry, buy_b.w, buy_b.h)
    if (btnp("select") and buy_b.hovered) then 
      current_item_displayed().bought = true
      player.coins = player.coins - current_item_displayed().price
    end
  end
  
end


arrow_sprite = 28 * 8 + 3
black = true

function draw_shop()

  local s = shop_w
  
  -- TITLE
    use_font("32")
    c_cool_print("Shop", GW/2, GH/12 + sin(t() / 3) * 5)
  --
  
  -- CLOSING ZONE
    rctf(s.x + s.w + 8, s.y - 20, 16, 16, _p_n("black"))
    rctf(s.x + s.w + 8 + 2, s.y - 20 + 2, 16 - 4, 16 - 4, _p_n("red"))
  --
  
  target(shop_surf)
  
  -- BACKGROUND
   
    rctf(6, 5, s.w - 12, s.h - 12, _p_n("black"))
    
        -- local offset = r + (t()*2 % 2) * r
        
        -- circfill(x , y + cos(x / shop_w.w) * shop_w.w / 8, r + 5, _p_n("purple"))
    -- for i = -1, ceil(shop_w.w / r*2) + 1 do
      -- for j = -1, ceil(shop_w.h / r*2) + 1 do
      
        -- local offset = 0
        -- local x = r * i + offset
        -- local y = r * j + offset
        -- circfill(x , y, 3 , _p_n("purple"))
      -- end 
    -- end

    local r = 15
    
    for i = -1, ceil(shop_w.w / r) + 1 do
      for j = -1, ceil(shop_w.h / r) + 1 do
        local offset = (t() * 6 )%r*2
        circfill(i * r*2 + offset , j * r*2 + offset , r , _p_n("purple"))
        
      end
    end
  --
  
  -- CATEGORIES
  
    -- left
      use_font("16")
      if s.choosen == 1 then
        rctf(0, s.h - s.ch, s.w/2, s.ch,       hover_l_c and _p_n("yellow") or _p_n("red"))
        c_cool_print("Wands", s.w/4, s.h - 32, _p_n("yellow"), _p_n("black"))
      else
        rctf(0, s.h - s.ch * 3/4, s.w/2, s.ch, hover_l_c and _p_n("yellow") or _p_n("white"))
        c_cool_print("Wands", s.w/4, s.h - 32 + s.ch * 1/8, _p_n("yellow"), _p_n("black"))
      end
    --
    
    -- right
      if s.choosen == 1 then
        rctf(s.w/2, s.h - s.ch * 3/4, s.w/2, s.ch, hover_r_c and _p_n("yellow") or _p_n("white"))
        c_cool_print("Accessories", s.w*3/4, s.h - 32 + s.ch * 1/8, _p_n("yellow"), _p_n("black"))
      else
        rctf(s.w/2, s.h - s.ch, s.w/2, s.ch,       hover_r_c and _p_n("yellow") or _p_n("red"))
        c_cool_print("Accessories", s.w*3/4, s.h - 32, _p_n("yellow"), _p_n("black"))
      end
    --
  
  --
  
  -- CONTENT
  
    local target_t = get_target_tab_shop(s.choosen)
    local ind = items_on_sale[s.choosen][s.index]
    
    -- local content = {name = target_t[ind].name, desc = target_t[ind].desc, price = target_t[ind].price}
    local content = {}
    content.name = target_t[ind].name
    content.desc = target_t[ind].desc
    content.price = target_t[ind].price
    
    use_font("32")
    c_cool_print(content.name, s.w/2, 15) 
    
    local str_h = str_height(content.name)
    use_font("16")
    
    -- local to_print = {content.desc}
    local to_print = cut_str(content.desc, s.w*2/3)
    
    local r = ""
    for i = 1, count(to_print) do
      local str = to_print[i]
      c_cool_print(r .. str, s.w/2, 15 + str_h * 1.5, _p_n("black"), _p_n("white")) 
      r = r .. "\n"
    end
    
    -- Price
    if not current_item_displayed().bought then
      local price_text = current_item_displayed().price .. " C"
      use_font("16")
      local pt_h = str_height(price_text)
      
      c_cool_print(price_text, s.w/2, s.h - s.ch - pt_h + cos(t()/2) * 2.5)
    end
  --
  
  -- ARROWS
      -- no_r_arrow = s.index == count(items_on_sale[s.choosen])
      -- no_l_arrow = s.index == 1
    -- left
      if not (s.index == 1) then
        local col = hover_l and _p_n("red") or _p_n("white")
        pal (_p_n("white"),col)
        spr(arrow_sprite, 8, s.h/2 - s.rh/2 - s.ch/4, 1, 3, true)
        pal()
      end
    --
    -- right
      if not (s.index == count(items_on_sale[s.choosen])) then
        local col = hover_r and _p_n("red") or _p_n("white")
        
        pal (_p_n("white"),col)
        spr(arrow_sprite,s.w - s.rw - 8, s.h/2 - s.rh/2 - s.ch/4, 1, 3)
        pal()
      end
      -- rctf(s.w - s.rw - 10, s.h/2 - s.rh/2 - s.ch/4, s.rw, s.rh) --,  hover_r and _p_n("red") or _p_n("white"))
    --
  
  --
  
  -- OUTLINE
    rct(0, 0, s.w, s.h, _p_n("white"))
    for i = 1, 4 do
      rct(i, i, s.w - i*2, s.h - i*2, _p_n("black"))
    end
    rct( 5, 5, s.w - 10, s.h - 10, _p_n("white"))
  --
  
  target()
  
  use_font("32")
  
  local y = buy_b.y
  
  if buy_b.hovered and not current_item_displayed().bought then y = y + cos(t()/2) * 5 end
  
  local text = current_item_displayed().bought and buy_b.bought_text or buy_b.buy_text
  
  -- c_cool_print(text, buy_b.x, y, buy_b.c[1], buy_b.c[2] ) 
  c_cool_print(text, buy_b.x, y, buy_b.can_buy and buy_b.c[1] or buy_b.c[3], buy_b.can_buy and buy_b.c[2] or buy_b.c[4]) 
  
  spr_sheet(shop_surf, s.x, s.y)
end

function current_item_displayed()
  if not shop_w or not items_on_sale then return end
  -- return get_wand_t("meteor_wand")
  local t = (shop_w.choosen == 1 and wands or shop_w.choosen == 2 and items)
  if not t then return end 
  return t[items_on_sale[shop_w.choosen][shop_w.index]]
end

