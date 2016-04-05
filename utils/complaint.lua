local component = require("component")
local term = require("term")
local process = require("process")
local unicode = require("unicode")
local text = require("text")

function createInput(x, y, width, height, length)
  local window = term.internal.open(x,y,width,height)
  term.bind(term.gpu(), term.screen(), term.keyboard(), window)
  window.max = length
  return window
end

function drawBorders(window)
  local w,h,x,y = term.getViewport(window)
  local borders = {{unicode.char(0x2552), unicode.char(0x2550), unicode.char(0x2555)},
                   {unicode.char(0x2502), nil, unicode.char(0x2502)},
                   {unicode.char(0x2514), unicode.char(0x2500), unicode.char(0x2518)}}
  local px,py = term.getCursor()
  term.setCursor(x-1,y)
  io.write(borders[1][1] .. string.rep(borders[1][2], w + 2) .. borders[1][3] .. "\n")
  for i=1,h do
    term.setCursor(x-1,y+i)
    io.write(borders[2][1] .. text.padRight("", w+2) .. borders[2][3] .. "\n")
  end
  term.setCursor(x-1,y+h+1)
  io.write(borders[3][1] .. string.rep(borders[3][2], w + 2) .. borders[3][3])
  term.setCursor(px,py)
end

function readInput(window, handler)
  local pdata = process.info().data
  local main_window = pdata.window

  local function pre_handler(input)
    if not handler then
      return true
    end
    
    if #input.data>window.max then
      pdata.window = main_window
      handler()
      pdata.window=window
      return false
    end
  
    return true
  end

  drawBorders(window)
  pdata.window = window
  local result

  pcall(function()
    term.clear()
    result = term.read({filter=pre_handler},false)
  end)

  pdata.window = main_window

  return result
end

local reasons = [[
1. - Offensive Name
2. - Use of X-Ray
3. - Duping
4. - Verbal Abuse
5. - Griefing
6. - Stealing/Raiding
]]

local reasonstable = {
"Offensive Name", "Use of X-Ray", "Duping", "Verbal Abuse", "Griefing", "Stealing/Raiding"
}

term.clear()
io.write("Greetings! Please use this program to lodge a complaint about a player or admin.\n")
io.write("Abuse of this program, filing false complaints, or spamming of complaints will\n")
io.write("result in being restricted from using this program, and/or a ban from the server,\n")
io.write("to be determined on a case by case basis.\n")
io.write("\n")
io.write("\n")
io.write("Please enter YOUR name: ")
local reporter = io.read("*line")
io.write("Please enter the name of the person you wish to report: ")
local reportee = io.read("*line")
io.write("Please choose one of the following options as the MAJOR reason you are reporting\n")
io.write("this person. Choose carefully, as this will determine what the staff member who\n")
io.write("receives the complaint does in response.\n")
io.write("\n")
io.write(reasons .. "\n\n")
local reason = io.read("*line")
local reasonnum = tonumber(reason)
reason = reasonstable[reasonnum]
io.write("Please give a brief description of your complaint in fewer than 200 characters")
print()

local px,py = term.getCursor()
local w = createInput(3, py+1, 20, 10, 200)
local complaint = readInput(w, function()
  term.setCursor(px,py)
  term.write("too much text")
end)
-- clean up error if printed
term.setCursor(px,py)
term.write("             ")
term.setCursor(1,w.dy+w.h+2)

if not complaint then
  io.stderr:write("complaint submission aborted\n")
  return 1
end

local pr = component.openprinter

pr.setTitle("Complaint - " .. reportee)

pr.writeln(" ")
pr.writeln("Reported by")
pr.writeln("   " .. reporter)
pr.writeln(" ")
pr.writeln("Reason for complaint:")
pr.writeln("   " .. reason)
pr.writeln(" ")
pr.writeln("Description of complaint")
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln(complaint:sub(1,20)) complaint=complaint:sub(21)
pr.writeln("Pretend Timestamp")

local prnt, err = pr.print()
if not prnt then
io.stderr:write(err)
end

pr.clear()
pr.setTitle(" ")
term.clear()
