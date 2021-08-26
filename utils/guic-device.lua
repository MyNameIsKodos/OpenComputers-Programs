-- This is a general use version of my Control GUI
--
-- version 1.0 by Kodos
--
-- Credit to Izaya for helping me unfuck the obvious dumb shit I was doing, as well as the escape codes for colors





-- Variables

local thing1Active = false
local thing2Active = false

local thing1Addr = "bbccab2f-bab0-4b36-9030-9daf8aa2560c" 
local thing2Addr = "c2ebfaf8-a279-4913-8f0d-95db8b5f9254"


-- Requires

local event = require("event")
local os = require("os")
local computer = require("computer")
local component = require("component")
local term = require("term")
local sides = require("sides")

-- Hardware

local thing1 = component.proxy(thing1Addr)
local thing2 = component.proxy(thing2Addr)

-- Misc

local char_space = string.byte(" ")
local char_thing1 = string.byte("1")
local char_thing2 = string.byte("2")

local running = true

-- Init

thing1.setEnabled(false)

thing2.setEnabled(false)

---

function toggleThing1()
  if thing1Active then
  thing1.setEnabled(false)
  thing1Active = false
  else thing1setEnabled(true)
  thing1Active = true
  end
end

function toggleThing2()
  if thing2Active then
  thing2.setEnabled(false)
  thing2Active = false
  else thing2setEnabled(true)
  thing2Active = true
  end
end



function updateDisplay()
term.clear()
term.setCursor(1,1)
term.write("Generic User Interface Control Systems v1.0\n\n")
term.write("Thing \27[7m1\27[0m Status: " .. (thing1Active and "\27[32mONLINE\n" or "\27[31mOFFLINE\n"))
term.write("\27[0mThing \27[7m2\27[0m Status: " .. (thing2Active and "\27[32mENABLED\n" or "\27[31mDISABLED\n"))
term.write("\27[0mPress SPACE to exit this program.")
end

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end})

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
    running = false
  term.clear()
  elseif (char == char_thing1) then
  toggleThing1()
  elseif (char == char_thing2) then
    toggleThing2()
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
