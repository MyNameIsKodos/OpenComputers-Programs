-- Version 0.51

-- Changelog:
-- Added TODO List
-- Mostly fixed indentation because OCD
-- Updated Pastebin with current code
-- Actually fixed indentation
-- Made lamp colours gradients


-- ==================================

-- TODO
-- Add a way to have a second lamp track net gain/loss of power
-- Make Lamp(s) optional *still*
-- Refactor (Is this even the right word) term.write to use 
-- gpu.set instead, as well as setting it up so that only the
-- values that change every update will be redrawn, instead of 
-- the entire GUI
-- Make things prettier on the front end

-- Code Start


local component = require("component")
local term = require("term")

local gpu = component.gpu            -- Note that this program requires a T3 Screen.

local lamp = component.colorful_lamp -- As of right now, a Computronics Lamp is required. 
                                     -- I may take another stab at making it optional later on,
                                     -- but for now, it's required or the program will not run.
									 
-- We're going to temporarily pretend that
-- this paragraph of text is my fancy function
-- that will allow my capacitor bank monitoring
-- program to simultaneously control my reactor
-- based upon whether or not the capacitor bank
-- has sufficient amounts of energy, as well as
-- whether its current power draw is high enough
-- to warrant enabling the reactor.

local blue = 0x1F

gpu.setResolution(32,1) -- For larger CapBank multiblocks, '32' may need to be increased to fit the amounts.

local function checkBatt()
  local curr = 0
  for addr in component.list("capacitor_bank") do
    battcheck = component.proxy(addr).getEnergyStored()
    curr = curr + battcheck
  end
  return curr
end

local function getMaxBatt()
  local maxStorage = 0
  for addr in component.list("capacitor_bank") do
    maxcheck = component.proxy(addr).getMaxEnergyStored()
    maxStorage = maxStorage + maxcheck
  end
  return maxStorage
end

local function updateMon(curr, maxStorage)
  term.clear()
  term.setCursor(1,1)
  io.stdout:write(curr .. "/" .. maxStorage .. " RF Stored.")
  return
end

local function updateLamp(curr, maxStorage)
  if curr == 0 and maxStorage == 0 then
    lamp.setLampColor(blue)
    return
  else
    local perc = curr / maxStorage
    local red = math.max(math.min(math.ceil(0x1C * ((1 - perc)*2)), 0x1C), 0)
    local green = math.max(math.min(math.ceil(0x1F * (perc * 2)), 0x1F), 0)
    lamp.setLampColor(bit32.bor(bit32.lshift(red, 10), bit32.lshift(green, 5)))
  end
end

function updateReactor()

end

while true do
  local maxStorage = getMaxBatt()
  local curr = checkBatt()
  updateMon(curr, maxStorage)
  updateLamp(curr, maxStorage)
  os.sleep(1)
end

-- Code End
