local component = require("component")
local serialization = require("serialization")
local term = require("term")
local shell = require("shell")

local gpu = component.gpu
local screen = component.screen

local kodos = {}
kodos.math = {}
kodos.textutils = {}
kodos.miscutils = {}
kodos.fileutils = {}
kodos.networkutils = {}
kodos.computils = {}

--[[
TODO:

* Add other component functions, accompanied by corresponding 'if component is available, etc' statements.
* Sort computils into subtables per component for more organization
* Stuff
* Things
]]


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


-- Non-standard Math Functions --

function kodos.math.round(num, idp)           
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Miscellaneous Utility Functions --

function kodos.miscutils.dump(mytab)          
  for k,v in pairs(mytab) do
    print(k,v)
  end
  return
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

-- Networking Functions --

function kodos.networkutils.prepare(data)     -- I realize this is just a wrapped serialize and unserialize function.
  serdata = serialization.serialize(data)     -- This lib is mostly for personal use, however anyone is free to use it, 
  return serdata                              -- or any code contained within.  - Kodos
end

function kodos.networkutils.receive(data)
  unserdata = serialization.unserialize(data)
  return unserdata
end

-- Component Functions --

if component.isAvailable("light_board") then
    
  function kodos.computils.setLight(indx,clr,onOff)
    component.light_board.setColor(indx,clr)
    component.light_board.setActive(indx,onOff)
    return 
  end
  
  function kodos.computils.blink(indx,clr) -- Only usable on the 4-light variant
    local cnt = component.light_board.light_count
    if cnt ~= 4 then 
	  return nil, "wrong board mode"
    else
      kodos.computils.setLight(indx,clr,true)
      os.sleep(.1)
	  kodos.computils.setLight(indx,clr,false)
      return true
    end
  end
  

  
  function kodos.computils.resetLight(a)
    kodos.computils.setLight(a,0xFFFFFF,false)
    return 
  end
  
  function kodos.computils.resetLights()
    for x = 1,component.light_board.light_count do
      kodos.computils.setLight(x,0xFFFFFF,false)
    end
    return 
  end
  
  function kodos.computils.disco(dur)
    local dur = (dur or 300)
	local timr = 0
    local lites = component.light_board.light_count
    while timr < dur do
      local lite = math.random(1,lites)
      chc = math.random(1,2)
      if chc == 1 then
        kodos.computils.setLight(lite,math.random(0xFFFFFF),true)
      elseif chc == 2 then
        kodos.computils.setLight(lite,math.random(0xFFFFFF),false)
      end
      timr = timr + 1
      os.sleep(0.05)
    end
    return 
  end

end

return kodos
