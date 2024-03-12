vim.api.nvim_create_user_command("CallerTree", require("cscope-calltree").caller_tree, {})
vim.api.nvim_create_user_command("CalleeTree", require("cscope-calltree").callee_tree, {})
