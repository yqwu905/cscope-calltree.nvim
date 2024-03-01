---@class CustomModule
local M = {}
local ui = require("cscope-calltree.ui")
local cscope = require("cscope-calltree.cscope")

M.init_caller_tree = function()
  ui.init(cscope.getCaller)
end

M.init_callee_tree = function()
  ui.init(cscope.getCallee)
end

return M
