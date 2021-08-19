-- Planetary Shield Status Program
--
-- version 0.25  by Kodos
--
-- Credit to Izaya for helping me unfuck the obvious dumb shit I was doing, as well as the escape codes for colors


local online = false
local bubble = false

local maxEnergy
local currEnergy


-- Requires

local event = require("event")
local os = require("os")
local computer = require("computer")
local component = require("component")
local term = require("term")

-- Hardware

local shield = component.planetary_shield

-- Misc

local char_space = string.byte(" ")
local char_enable = string.byte("s")
local char_bubble = string.byte("b")

local running = true

-- Init

shield.setBubbleVisible(bubble) -- Fix this later
shield.setEnabled(online) -- And this

maxEnergy = shield.getMaxEnergy() -- And this
currEnergy = shield.getStoredEnergy()  -- Annnnd this

---

function toggleOnline()
  if online then
  shield.setEnabled(false)
  online = false
  else shield.setEnabled(true)
  online = true
  end
end

function toggleBubble()
  if bubble then
  shield.setBubbleVisible(false)
  bubble = false
  else shield.setBubbleVisible(true)
  bubble = true
  end
end



function updateDisplay()
term.clear()
term.setCursor(1,1)
term.write("Planetary Shield System\n\n")
term.write("Power Levels: " .. tostring(currEnergy) .. "/" .. tostring(maxEnergy) .. "\n\n")
term.write("Shield Status:  " .. (online and "\27[32mONLINE\n" or "\27[31mOFFLINE\n"))
term.write("\27[0mEffect Bubble Visibility:  " .. (bubble and "\27[32mENABLED\n" or "\27[31mDISABLED\n"))
term.write("\27[0mPress SPACE to exit this program.")
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
  elseif (char == char_bubble) then
    toggleBubble()
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
