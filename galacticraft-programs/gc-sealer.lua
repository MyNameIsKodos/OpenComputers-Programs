-- Oxygen Sealer Status Program
--
-- Code based on my Planetary Shield program
-- 
-- version 0.25  by Kodos
--
-- Credit to Izaya for helping me unfuck the obvious dumb shit I was doing, as well as the escape codes for colors


local online = false

local maxEnergy
local currEnergy
local currOxygen

-- Requires

local event = require("event")
local os = require("os")
local computer = require("computer")
local component = require("component")
local term = require("term")

-- Hardware

local sealer = component.oxygen_sealer

-- Misc

local char_space = string.byte(" ")
local char_enable = string.byte("o")
local char_refresh = string.byte("r")

local running = true

-- Init

sealer.setEnabled(online) -- And this
maxEnergy = sealer.getMaxEnergy() -- And this
currEnergy = sealer.getStoredEnergy()  -- Annnnd this
currOxygen = sealer.getOxygenTank().amount

---

function toggleOnline()
  if online then
  sealer.setEnabled(false)
  online = false
  else sealer.setEnabled(true)
  online = true
  end
end

function updateDisplay()
term.clear()
term.setCursor(1,1)
term.write("Oxygen Sealer Systems\n\n")
term.write("Sealer O2 Storage: \27[36m" .. tostring(currOxygen) .. "\27[0m\n")
term.write("Power Levels: " .. tostring(currEnergy) .. "/" .. tostring(maxEnergy) .. "\n\n")
term.write("Sealer Status:  " .. (online and "\27[32mONLINE\n\27[0m" or "\27[31mOFFLINE\27[0m\n"))
term.write("Sealed: " .. (sealer.isSealed() and "\27[32mYES\n\27[0m" or "\27[31mNO\n\27[0m"))
term.write("Press SPACE to exit this program.")
end

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end})

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
    running = false
  term.clear()
  elseif (char == char_enable) then
  toggleOnline()
  elseif (char == char_refresh) then
  updateDisplay()
  end
end

function handleEvent(eventID, ...)
  if (eventID) then 
    myEventHandlers[eventID](...)
  end
end

while running do
 updateDisplay()
 handleEvent(event.pull())
end
