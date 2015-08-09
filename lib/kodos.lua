local kodos = {}
kodos.math = {}
kodos.textutils = {}
kodos.miscutils = {}
kodos.fileutils = {}

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

return kodos
