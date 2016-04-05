local component = require("component")
local event = require("event")
local os = require("os")

local door = component.os_door
local char_space = string.byte(" ")
local running = true

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
  running = false
  end
  end

local function openDoor()
  door.toggle()
  os.sleep(3)
  door.toggle()
  return
end

--[[
local function Set(list)
  local set = {}
for _,val in ipairs(list) do
set[val] = true
end
return set
end
]]

local authcard = {}

for line in io.lines("/etc/authcard.dat") do
  table.insert(authcard, line)
end

local authuser = {}

for line in io.lines("/etc/authuser.dat") do
  table.insert(authuser, line)
end

--[[

Hokay.  So... I still need to fix this.  Basically the gist will be that there are two files.
One will have stored magCard UUIDs that are from authorized cards (I've been adding these
IDs manually because I can't think of a sane way to do it in code.)  The other file is for
basically a whitelist of authorized users that the program checks against. I mainly needed
this part because I want to have a way of knowing when someone who isn't on the list is 
trying to use a card from someone that is on the list. Yes, I know it's probably bad since
a whitelisted person can't just toss someone their card to use, but it's for security, so
that's pretty much already out the window anyway. Someone who works at a nuclear research
facility wouldn't just hand their card out willy nilly.  

Anyway, the original idea was to
use the Set function (Seen in comments above) to set the whitelist of users and authorized
card UUIDs to true, but I have no idea how to change how I'm checking the cards currently
to accomodate that.  Part of that might be because I'm coding at 4 AM.  But most of it is
probably because I know fuckall for what I'm doing.

tl;dr Any help is appreciated on fixing this so that all the checks work (Stolen cards being
used is logged, etc). Thanks in advance. - Kodos

]]


function myEventHandlers.magData(addr, playerName, data, UUID)
for i = 1,#authorized do
-- print("Checking index #" .. i .. " for a match against: " .. UUID)
if UUID == authorized[i] and playerName == data then
print("Door opening for " .. playerName .. ".")
openDoor()
break
elseif UUID ~= authorized[i] and playerName ~= data then
print("Unauthorized Access Attempt from " .. playerName) -- Fix this later to use logging
break
elseif UUID ~= authorized[i] then
print("Unauthorized card used by " .. playerName) -- Also fix this later
break
elseif playerName ~= data then
print(playerName .. " tried to use a card stolen from " .. data) -- And fix this
end
end
end

function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end

while running do
handleEvent(event.pull())
end
