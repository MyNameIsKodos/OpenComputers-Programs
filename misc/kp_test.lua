-- User Variables

local pin = 1234 -- Change this to whatever you want the PIN to be. No more than 8 chars

-- Requires

local component = require("component")
local event = require("event")
local os = require("os")
local computer = require("computer")

-- Hardware

local kp = component.os_keypad


-- Misc

local char_space = string.byte(" ")
local running = true
local currButton = ""


-- Keypad init

kpButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "CL", "0", "OK"}
kpColors = {15, 15, 15, 15, 15, 15, 15, 15, 15, 12, 15, 10}
kp.setKey(kpButtons, kpColors)

---

function display(text,color)
kp.setDisplay(text,color)
os.sleep(.5)
kp.setDisplay("", 15)
end

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end})

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
    running = false
  end
end

function myEventHandlers.keypad(address, id, buttonLabel)
if (id == 10) then
  currButton = ""
  kp.setDisplay("", 15)
else if (id == 12) then
  if (currButton == tostring(pin)) then
    currButton = ""
    display("GRANTED", 10)
  else
    currButton = ""
    display("DENIED", 12)
  end
else
  currButton = currButton .. buttonLabel
  kp.setDisplay(currButton, 15)
end
end
end

function handleEvent(eventID, ...)
  if (eventID) then 
    myEventHandlers[eventID](...)
  end
end

while running do
 handleEvent(event.pull())
end
