local component = require("component")
local pr = component.openprinter

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
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")
pr.writeln(" ")

local prnt, err = pr.print()
if not prnt then
io.stderr:write(err)
end

pr.clear()
pr.setTitle(" ")
