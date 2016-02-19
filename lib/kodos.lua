local component = require("component")
local serialization = require("serialization")
local term = require("term")
local shell = require("shell")

local gpu = component.gpu
local screen = component.screen

local kodos = {}
  kodos.computils = {}
  kodos.computils.os_keypad = {}
  kodos.computils.light_board = {}
  kodos.fileutils = {}
  kodos.mathutils = {}
  kodos.miscutils = {}
  kodos.networkutils = {}
  kodos.secutils = {}
  kodos.textutils = {}

--[[
TODO:

* Add other component functions, accompanied by corresponding 'if component is available, etc' statements.
* Stuff
* Things
]]

-- Component Functions --

if component.isAvailable("light_board") then
  
  function kodos.computils.light_board.setLight(indx,clr,onOff)
    component.light_board.setColor(indx,clr)
    component.light_board.setActive(indx,onOff)
    return 
  end
  
  function kodos.computils.light_board.blink(indx,clr) -- Only usable on the 4-light variant
    local cnt = component.light_board.light_count
    if cnt ~= 4 then 
      return nil, "wrong board mode"
    else
      kodos.computils.light_board.setLight(indx,clr,true)
      os.sleep(.1)
      kodos.computils.light_board.setLight(indx,clr,false)
      return true
    end
  end
  
  function kodos.computils.light_board.resetLight(a)
    kodos.computils.light_board.setLight(a,0xFFFFFF,false)
    return 
  end
  
  function kodos.computils.light_board.resetLights()
    for x = 1,component.light_board.light_count do
      kodos.computils.light_board.setLight(x,0xFFFFFF,false)
    end
    return 
  end
  
  function kodos.computils.light_board.setMeter(curr,max)
    local totalLights = component.light_board.light_count
    if max == 0 then
      for i = 1,totalLights do
        kodos.computils.light_board.setLight(i,0x0000FF,true)
      end
      return nil, "no max value found"
    else
      local lightsOn = math.ceil((curr/(max/100))*(totalLights/100))
      for l = 1,totalLights do
        component.light_board.setActive(l,(l <= lightsOn))
      end
    end
    return
  end
  
  function kodos.computils.light_board.disco(dur)
    local dur = (dur or 300)
    local timr = 0
    local lites = component.light_board.light_count
    while timr < dur do
      local lite = math.random(1,lites)
      chc = math.random(1,2)
      if chc == 1 then
        kodos.computils.light_board.setLight(lite,math.random(0xFFFFFF),true)
      elseif chc == 2 then
        kodos.computils.light_board.setLight(lite,math.random(0xFFFFFF),false)
      end
      timr = timr + 1
      os.sleep(0.05)
    end
  end
  
end

if component.isAvailable("os_keypad") then
  
  function kodos.computils.os_keypad.setDisplay(displayText,duration,textColor)
    if textColor then
      component.os_keypad.setDisplay(displayText, textColor)
      os.sleep(duration)
      component.os_keypad.setDisplay("",textColor)
    elseif not textColor then
      component.os_keypad.setDisplay(displayText)
      os.sleep(duration)
      component.os_keypad.setDisplay("")
    end
  end
  
end


-- File Utitily Functions --

function kodos.fileutils.readFile(filename)   
  local file, err = io.open(filename,"rb")
  if not file then
    return nil, err
  end
  local data = file:read("*a")
  file:close()
  return data
end

function kodos.fileutils.writeToFile(data,filename,overwrite)
  local fhand,err = io.open(filename,overwrite and "w" or "a")
  if not fhand then
    return nil,err
  end
  fhand:write(data)
  fhand:close()
end

-- Non-standard Math Functions --

function kodos.mathutils.round(num, idp)           
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Miscellaneous Utility Functions --

function kodos.miscutils.dump(mytab)          
  for k,v in pairs(mytab) do
    print(k,v)
  end
end

function kodos.miscutils.detable(table, indent)
  indent = indent or 0;
  for k, v in pairs(tab) do 
    if type(v) == "table" then 
      print(string.rep(" ", indent).. tostring(k) .. ">") 
      detable(v, indent + 2) 
    else print(string.rep(" ", indent) .. tostring(k) .. " = " .. tostring(v)) 
    end
  end
end

-- Networking Functions --

function kodos.networkutils.prepare(data)     -- I realize this is just a wrapped serialize and unserialize function.
  serdata = serialization.serialize(data)     -- This lib is mostly for personal use, however anyone is free to use it, 
  return serdata                              -- or any code contained within.  - Kodos
end

function kodos.networkutils.receive(data)
  unserdata = serialization.unserialize(data)
  return unserdata
end

-- Security Utilities --

function kodos.secutils.logData(username, arg)
  if not fs.get("/").isReadOnly() then
    if not fs.exists("/logs/") then
      fs.makeDirectory("/logs/")
    end
    userw = io.open("/logs/auth.log", "a")
    if (userw) then
      userw:write(username .. " | " .. arg .. "\n")
      userw:close()
    elseif not (userw) then
      io.stderr:write("Error opening log file")
    end
  elseif fs.get("/").isReadOnly() then
    io.stderr:write("Error writing to log file. Filesystem is read-only")
  end
end


-- Text Utility Functions --

function kodos.textutils.str2hex(a)
  return a:gsub(".",function(a)
    return string.format("%02x",a:byte())
  end)
end

function kodos.textutils.hex2str(a)
  return a:gsub("..",function(a)
    return string.char(tonumber(a,16))
  end)
end

function kodos.textutils.justify(a,b,c)
  if c == "center" then
    local str = b
    local maxX, maxY = gpu.getResolution()
    local start = ((maxX - #str) / 2) + 1
    gpu.set(start,a,str)
  elseif c == "right" then
    local str = b
    local maxX, maxY = gpu.getResolution()
    local start = (maxX - #str) + 1
    gpu.set(start,a,str)
  elseif c == "left" then
    local str = b
    gpu.set(1,a,str)
  end
end

return kodos
