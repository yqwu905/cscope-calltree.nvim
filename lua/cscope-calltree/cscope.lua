local M = {}

local function cscope_parse_line(line)
  local t = {}
  local sp = vim.split(line, "%s+")

  t.filename = sp[1]
  t.ctx = sp[2]
  t.lnum = sp[3]
  local sz = #sp[1] + #sp[2] + #sp[3] + 3
  t.text = string.sub(line, sz, -1)

  return t
end

local function cscope_parse_output(output)
  local res = {}
  for line in string.gmatch(output, "([^\n]+)") do
    local parsed = cscope_parse_line(line)
    table.insert(res, parsed)
  end
  return res
end

local function cscope_cmd_helper(op_n, symbol)
  local cmd = "cscope -dL -" .. op_n .. " " .. symbol
  local file = assert(io.popen(cmd, "r"))
  file:flush()
  local output = file:read("*all")
  file:close()
  local res = cscope_parse_output(output)
  return res
end

function M.getCaller(symbol)
  return cscope_cmd_helper(3, symbol)
end

function M.getCallee(symbol)
  return cscope_cmd_helper(2, symbol)
end

return M
