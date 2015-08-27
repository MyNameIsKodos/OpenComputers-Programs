local component = require("component")
local serialization = require("serialization")
local gpu = component.gpu
local screen = component.screen

local kodos = {}
  kodos.math = {}
  kodos.textutils = {}
  kodos.miscutils = {}
  kodos.fileutils = {}
  kodos.networkutils = {}



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
  local maxX, maxY = gpu.maxResolution()
  local start = (maxX - #str) / 2
  gpu.set(start,a,str)
  elseif c == "right" then
  local str = b
  local maxX, maxY = gpu.maxResolution()
  local start = maxX - #str
  gpu.set(start,a,str)
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

function kodos.networkutils.prepare(data)   -- I realize this is just a wrapped serialize and unserialize function.
  serdata = serialization.serialize(data)     -- This lib is mostly for personal use, however anyone is free to use it, 
  return serdata                              -- or any code contained within.  - Kodos
end

function kodos.networkutils.receive(data)
  unserdata = serialization.unserialize(data)
  return unserdata
end

return kodos
