# Call hierarchy tree plugin base on [cscope](https://cscope.sourceforge.net/)

> [!CAUTION]
> This plugin is a work in progress. It currently implements only the most basic functionality and may contain bugs.

## Install
With [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
    "yqwu905/cscope-calltree.nvim",
    dependencies = {
        { "MunifTanjim/nui.nvim" },
    },
    opts = {},
    keys = {
        { "<leader>ci", "<cmd>CallerTree<cr>", desc = "caller tree" },
        { "<leader>co", "<cmd>CalleeTree<cr>", desc = "callee tree" },
    },
}
```

## Usage
This plugin provide two command: `CallerTree` and `CalleeTree`. These commands will open a split window
contain a call hierarchy tree with following mapping:

| Key | Description                                        |
|-----|----------------------------------------------------|
| l   | Expand node or get caller/callee of current symbol |
| h   | Collapse node                                      |
| K   | Show basic information of this node                |
| q   | Close split window                                 |

## Configuration

Currently no configurations are provided;

## Roadmap
- [ ] Add some configurable options, such as split size and position, tree depth on startup...
- [ ] More information about node.
- [ ] Combine caller and callee into one ui.
