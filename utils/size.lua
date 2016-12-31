local shell = require("shell")
local fs = require("filesystem")

local args, options = shell.parse(...)

local file = args[1]

size = fs.size(file)

function round(num, idp)
local mult = 10^(idp or 0)
return math.floor(num * mult + 0.5) / mult
end

if not options.a and size >= 1024 then
-- print("This worked.")
size = size / 1024
-- print("So did this.")
size = round(size, 2)
-- print("And finally this.")
print("File size of " .. file .. " is " .. size .. " kilobytes.")
elseif options.a or size <= 1024 then  print("File size of " .. file .. " is " .. size .. " bytes.")
end