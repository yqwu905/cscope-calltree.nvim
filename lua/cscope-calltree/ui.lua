local M = {}

local NuiSplit = require("nui.split")
local NuiPopup = require("nui.popup")
local NuiAutocmd = require("nui.utils.autocmd")
local NuiEvent = require("nui.utils.autocmd").event
local NuiTree = require("nui.tree")

local cscope_node = function(cscope_output)
  return NuiTree.Node({
    text = cscope_output.ctx,
    filename = cscope_output.filename,
    lnum = cscope_output.lnum,
    code = cscope_output.text,
  })
end

function M.init(fun)
  local root_symbol = vim.fn.expand("<cword>")
  local origin_window = vim.api.nvim_get_current_win()
  -- TODO: Make these parameters configurable
  local split = NuiSplit({
    relative = "editor",
    position = "bottom",
    size = "40%",
  })
  split:mount()

  local tree = NuiTree({
    bufnr = split.bufnr,
    nodes = {
      NuiTree.Node({
        text = root_symbol,
        filename = vim.api.nvim_buf_get_name(0),
        lnum = vim.api.nvim_win_get_cursor(0)[1],
        code = vim.api.nvim_get_current_line(),
      }),
    },
  })

  tree:render()

  split:map("n", "l", function()
    local node, linenr = tree:get_node()
    if not node:has_children() then
      local symbols = fun(node.text)
      for _, symbol in ipairs(symbols) do
        tree:add_node(cscope_node(symbol), node:get_id())
      end
      tree:render()
    end
    if node and node:expand() then
      vim.api.nvim_win_set_cursor(split.winid, { linenr, 0 })
      tree:render()
    end
  end)

  split:map("n", "h", function()
    local node, _ = tree:get_node()
    if node:is_expanded() then
      node:collapse()
    end
    tree:render()
  end)

  split:map("n", "K", function()
    local node, _ = tree:get_node()
    local popup = NuiPopup({
      relative = "cursor",
      position = {
        row = 1,
        col = 0,
      },
      size = {
        width = 120,
        height = 5,
      },
    })

    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, {
      string.format("File: %s:%d", node.filename, node.lnum),
      string.format("Code: %s", node.code),
    })

    NuiAutocmd.buf.define(split.bufnr, NuiEvent.CursorMoved, function()
      popup:unmount()
    end, { once = true })

    popup:mount()
  end)

  split:map("n", "<Enter>", function()
    local node, _ = tree:get_node()
    if node.filename then
      vim.api.nvim_set_current_win(origin_window)
      vim.api.nvim_command("edit " .. node.filename)
      vim.api.nvim_command("normal!" .. node.lnum .. "G")
    end
  end)
end

return M
