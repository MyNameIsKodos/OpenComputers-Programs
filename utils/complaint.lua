local component = require("component")
local term = require("term")

local pr = component.openprinter

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

pr.setTitle("Complaint - " .. reportee)

pr.writeln(" ")
pr.writeln("Reported by")
pr.writeln("   " .. reporter)
pr.writeln(" ")
pr.writeln("Reason for complaint:")
pr.writeln("   " .. reason)
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln("Pretend Timestamp")

local prnt, err = pr.print()
if not prnt then
io.stderr:write(err)
end

pr.clear()
pr.setTitle(" ")
term.clear()
