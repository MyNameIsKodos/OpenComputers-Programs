local component = require("component")
local event = require("event")
local os = require("os")

local cb = component.chat_box
local op = component.openprinter

local char_space = string.byte(" ")
local running = true
local char_pause = string.byte("p")

cb.setName("Dave")

local messages = {
  
  ["hello"] = {
    --Syntax: ["keyword"] = {function, all, other, arguments}
    ["Conor"] = {cb.say, "Hello, Conor."},
    ["Dorrin"] = {cb.say, "Hello, Dorrin."},
    ["Bal"] = {cb.say, "Hello, Baloin"}
  },
  
  ["printer"] = {
    ["paper"] = {cb.say, "The paper level is at " .. op.getPaperLevel() .. "."},
    ["black ink"] = {cb.say, "The black ink level is at " .. op.getBlackInkLevel() .. "."},
    ["color ink"] = {cb.say, "The color ink level is at " .. op.getColorInkLevel() .. "."}
  },
  
  ["awesome"] = {
    ["you're"] = {cb.say, "No, you're awesome."}
  }
  
}

local function openDoor()
  door.toggle()
  os.sleep(5)
  door.toggle()
  return
end

local function cardMenu()
  term.clear()
  term.setCursor(1,1)
  print("Do you wish to add or remove a UUID? (A/r)")
  choice = io.read()
  if choice and (choice == "" or choice:sub(1,1):lower() == "a") then
    choice = "a" -- I have no idea where I was going with this
  else choice = "r"
  end
  return choice
end

--[[ local function authorized()
  local env = {}
  local config = loadfile("/etc/auth.dat", nil, env)
  if config then
    pcall(config)
  end
  return env.authorized
end

local authorized = authorized() -- This one? ]]

local function getFunction(tbl, msg)
  if tbl[1] then
    return tbl
  end
  for i,j in pairs(tbl) do
    if type(i) == "string" then
      -- print(i)
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

function unknownEvent()
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
    running = false
    --[[elseif (char == char_pause) then
    cardMenu()
    doChoice()  ]]--
  end
end

function myEventHandlers.chat_message(adr,playerName,message)
  if message:find("^%Dave, .+") then
    local result, response = parseMessage(message:lower())
  end
end




--[[function myEventHandlers.magData(addr, playerName, data, UUID, locked)
  for i = 1,#authorized do
    -- print("Checking index #" .. i .. " for a match against: " .. UUID)
    if UUID == authorized[i] then
      print("Door opening for " .. playerName .. ".")
      openDoor()
      break
    elseif UUID ~= authorized[i] then
      print("Unauthorized Access attempt from " .. playerName .. "!")
    end
  end
end]]

function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end

while running do
  handleEvent(event.pull())
end
