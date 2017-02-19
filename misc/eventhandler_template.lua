-- User Variables


-- Requires

local event = require("event")
local os = require("os")
local computer = require("computer")


-- Hardware


-- Misc

local char_space = string.byte(" ")
local running = true


---

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end})

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
    running = false
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
