local kodos = {}

function kodos.str2hex(a)                 -- textutils
  return a:gsub(".",function(a)
    return string.format("%02x",a:byte())
  end)
end

function kodos.hex2str(a)                 -- textutils
  return a:gsub("..",function(a)
    return string.char(tonumber(a,16))
  end)
end

function kodos.round(num, idp)            -- math
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function kodos.dump(mytab)                -- Not even sure what to categorize this into. Using it for method dump atm
  for k,v in pairs(mytab) do
    print(k,v)
  end
  return
end

function kodos.readFile(filename)         -- fileutils
  local file, err = io.open(filename,"rb")
  if not file then
    return nil, err
  end
  local data = file:read("*a")
  file:close()
  return data
end

return kodos
