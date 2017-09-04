-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

-- half left
hs.hotkey.bind({"alt"}, "h", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- half right
hs.hotkey.bind({"alt"}, "l", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- maximise
hs.hotkey.bind({"alt"}, "m", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- center
centered = 0
hs.hotkey.bind({"alt"}, "c", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  if centered == 0 then
    f.x = max.x + max.w * 1 / 3
    f.y = max.y
    f.w = max.w/2
    f.h = max.h
  elseif centered == 1 then
    f.x = max.x + max.w * 1 / 3
    f.y = max.y
    f.w = max.w/2
    f.h = max.h/2
  end 
  win:setFrame(f)
  centered = (centered + 1) % 2
end)

-- reload
hs.hotkey.bind({"cmd"}, "9", function()
  hs.reload()
end)
hs.alert.show("Config loaded")