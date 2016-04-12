local component = require("component")
local term = require("term")

local debug = component.debug

local function getStats(player)
local x,y,z = debug.getPlayer(player).getPosition()
local dim,dimname = debug.getPlayer(player).getWorld().getDimensionId(), debug.getPlayer(player).getWorld().getDimensionName()
return x,y,z,dim,dimname
end


term.clear()

local players = debug.getPlayers()


for cnt = 1,#players do
local x,y,z,dim,dimname = getStats(players[cnt])
print("Player Name: " .. player)
print("Player Location: " .. x .. ", " .. z)
print("Player Altitude: " .. y)
print("Player is in Dimension: " .. dim .. " - " .. dimname)
end

