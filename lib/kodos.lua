local component = require("component")
local gpu = component.gpu
local screen = component.screen

-- Ignore these four words

local kodos = {}
kodos.math = {}
kodos.textutils = {}
kodos.miscutils = {}
kodos.fileutils = {}
kodos.networkutils = {}

function kodos.textutils.str2hex(a)                 -- textutils
  return a:gsub(".",function(a)
    return string.format("%02x",a:byte())
  end)
end

function kodos.textutils.hex2str(a)                 -- textutils
  return a:gsub("..",function(a)
    return string.char(tonumber(a,16))
  end)
end

function kodos.textutils.center(a,b)
  local str = b
  local maxX, maxY = gpu.maxResolution()
  local start = (maxX - #str) / 2
  gpu.set(start,a,str)
end

function kodos.math.round(num, idp)            -- math
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function kodos.miscutils.dump(mytab)                -- Not even sure what to categorize this into. Using it for method dump atm
  for k,v in pairs(mytab) do
    print(k,v)
  end
  return
end

function kodos.fileutils.readFile(filename)         -- fileutils
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

if component.isAvailable("data") or component.isAvailable("os_datablock") then
function kodos.networkutils.prepare(data)        -- TODO: Actually write the functions
end

function kodos.networkutils.receive(data)
end
else
function kodos.networkutils.prepare(data)
end

function kodos.networkutils.receive(data)
end

end

return kodos
