cadavres = {}


function add_cadavre(e, x, y)

  add(cadavres, {
  
    id = e.id,
    s = get_a(e).s + 2,
    
    x = x,
    y = y,
    
    timer = 45,
    a = rnd(1),
  
  
  })

end

function update_cadavres()

  for i, c in pairs(cadavres) do
  
    c.timer = c.timer - dt()
    if c.timer < 0 then cadavres[i] = nil end
  
  end

end

function draw_cadavres()

  for i, c in pairs(cadavres) do
    local x = c.x
    local y = c.y
    local h = get_t(c).h
    local w = get_t(c).w
    
    a_outlined(c.s, x, y, c.a, 1, 1, .5, .5) 
  
  end

end