local component = require("component")
local filesystem = require("filesystem")
local shell = require("shell")

if not component.isAvailable("data") then
  print("Need a data card")
  return
end

local args, opts = shell.parse(...)
if #args < 1 then
  print([[
  Usage: compressdir directory
  Options:
  -d  Decompress directory]])
  return
end
local place = shell.resolve(args[1])
if not filesystem.exists(place) then
  print("No such path")
  return
elseif not filesystem.isDirectory(place) then
  print("Not a directory")
  return
end

local operation = component.data[opts.d and "inflate" or "deflate"]

for entry in filesystem.list(place) do
  if not filesystem.isDirectory(place .. "/" .. entry) then
    local file, err = io.open(place .. "/" .. entry,"rb")
    if not file then
      print(err)
    else
      local data = file:read("*a")
      file:close()
      data, err = operation(data)
      if not data then
        print(err)
      else
        local file, err = io.open(place .. "/" .. entry,"wb")
        if not file then
          print(err)
        else
          file:write(data)
          file:close()
        end
      end
    end
  end
end
