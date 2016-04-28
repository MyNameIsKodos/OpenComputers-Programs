local component = require("component")
local shell = require("shell")

local op = component.openprinter

local args, options = shell.parse(...)

local player = options.player
local amt = options.amount

