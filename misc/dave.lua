local component = require("component")
local colors = require("colors")
local sides = require("sides")
local event = require("event")

local rs = component.redstone
local cb = component.chat_box
local cl = component.colorful_lamp
local de = component.draconic_storage
local ni = component.notification_interface -- TODO: Correct component name
local db = component.debug
local ws = component.world_sensor -- TODO: Correct this one too



-- ChatBox init
cb.setName("Dave")

if cb.getDistance() < 32768 then
cb.setDistance(32768)
end

local function rgbto15(r,g,b) 
  return (b%32)+((g%32)*32)+((r%32)*1024) 
end

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

local messages = {

  ["lights"] = {
    --Syntax: ["keyword"] = {function, all, other, arguments}
    ["on"] = {rs.setBundledOutput, sides.back, colors.cyan, 15},
    -- ["on"] = {rs.setBundledOutput, sides.back, colors.orange, 15},
    ["off"] = {rs.setBundledOutput, sides.back, colors.cyan, 0},
    -- ["off"] = {rs.setBundledOutput, sides.back, colors.orange, 0}
  },

  ["door"] = {
    ["open"] = {rs.setBundledOutput, sides.back, colors.magenta, 15},
    ["close"] = {rs.setBundledOutput, sides.back, colors.magenta, 0}
  },

  ["all machines"] = {
    ["on"] = {cl.setLampColor, rgbto15(0,255,0)},
    ["off"] = {cl.setLampColor, rgbto15(255,0,0)}
  },

  ["core"] = {
    ["current"] = {cb.say, tostring(de.getEnergyStored())},
    ["max"] = {cb.say, tostring(de.getMaxEnergyStored())}
  }
  
  ["reactor"] = {
  ["fuel"] = {}
  }
  
  }
  

local function getFunction(tbl, msg)
  if tbl[1] then
    return tbl
  end
  for i,j in pairs(tbl) do
    if type(i) == "string" then
      print(i)
      if msg:find(i) and type(j) == "table" then
        return getFunction(j, msg)
      end
    end
  end
end

local function parseMessage(msg)
  local fnc = getFunction(messages, msg)
  if not fnc then return false, "no command found" end
  return pcall(table.unpack(fnc))
end

while true do
local _, _, user, message = event.pull("chat_message")
local result, response = parseMessage(message:lower())
print(result)
print(response)
end
