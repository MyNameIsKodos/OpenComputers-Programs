local component = require("component")
local os = require("os")
local term = require("term")

local gpu = component.gpu

if component.isAvailable("colorful_lamp") then
local lamp = component.colorful_lamp
end


orange = 25984
yellow = 32736
red = 25600
green = 992
blue = 31


gpu.setResolution(32,1)

function checkBatt()
 curr = 0
 for addr, name in (component.list("capacitor_bank")) do
  battcheck = component.proxy(addr).getEnergyStored()
  curr = curr + battcheck
 end
 return curr
end

function getMaxBatt()
max = 0
for addr, name in (component.list("capacitor_bank")) do
maxcheck = component.proxy(addr).getMaxEnergyStored()
max = max + maxcheck
end
return max
end

function updateMon()
term.clear()
term.setCursor(1,1)
io.stdout:write(curr .. "/" .. max .. " RF Stored.")
return
end

if component.isAvailable("colorful_lamp") then
function updateLamp()
max = getMaxBatt()
curr = checkBatt()
perc = (curr / max) * 100
if perc > 75 then do
lamp.setLampColor(green)
end
elseif perc <= 75 and perc > 50 then do
lamp.setLampColor(yellow)
end
elseif perc <=50 and perc > 25 then do
 lamp.setLampColor(orange)
end
elseif perc < 25 then do
lamp.setLampColor(red)
end
elseif curr == 0 and max == 0 then do
 lamp.setLampColor(blue)
end
end
return
end
else function updateLamp()
end
end


while true do
max = getMaxBatt()
curr = checkBatt()
updateMon()
updateLamp()
os.sleep(1)
end
