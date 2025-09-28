# footnode.nvim

A Neovim plugin for looking up visual selections in Wikipedia and automatically
creating markdown footnotes with the results.

## Features

- Look up selected text in Wikipedia
- Preview results in a clean floating window
- Automatically insert markdown footnotes with the selected definition/summary
- Works only in markdown files to keep your notes organized

## Requirements

- Neovim >= 0.7.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "navicore/footnode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = "markdown",  -- Load only for markdown files
  cmd = { "FootnoteLookup", "Footnode" },  -- Load when commands are used
  keys = {
    { "<leader>fl", mode = "v", desc = "Lookup selection and create footnote" },
  },
  config = function()
    require("footnode").setup({
      -- Optional configuration
      wikipedia = {
        api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/",
      },
      keymaps = {
        lookup = "<leader>fl", -- Default keymap for lookup
      },
    })
  end,
}
```

## Usage

1. In a markdown file, visually select any text you want to look up
2. Press `<leader>fl` (or your configured keymap)
3. A floating window will open showing the Wikipedia summary
4. Press `y` or `<Enter>` to create a footnote, `q` or `<Esc>` to cancel
6. The plugin will automatically:
   - Insert a footnote reference `[^1]` after your selected text
   - Add the footnote content at the bottom of your file

### Commands

- `:FootnoteLookup` - Look up visually selected text
- `:Footnode lookup` - Alternative command for lookup

### Example

If you select the word "telescope" and choose a Wikipedia result, your markdown
will be updated like:

```markdown
The telescope[^1] is an amazing invention.

[^1]: Telescope: A telescope is an optical instrument using lenses, curved mirrors, or a combination of both to observe distant objects... <https://en.wikipedia.org/wiki/Telescope> [Wikipedia]
```

## Configuration

```lua
require("footnode").setup({
  wikipedia = {
    api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/",
  },
  keymaps = {
    lookup = "<leader>fl",  -- Keymap for visual mode lookup
  },
  footnote_format = "[^%d]: %s",  -- Format for footnote content
})
```

## License

MIT
