# footnode.nvim

A Neovim plugin for looking up visual selections in dictionaries and Wikipedia,
displaying results in Telescope, and automatically creating markdown footnotes.

## Features

- Look up selected text in online dictionary and Wikipedia
- Preview results in Telescope with formatted display
- Automatically insert markdown footnotes with the selected definition/summary
- Works only in markdown files to keep your notes organized

## Requirements

- Neovim >= 0.7.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "navicore/footnode.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("footnode").setup({
      -- Optional configuration
      sources = {
        dictionary = {
          enabled = true,
          api_url = "https://api.dictionaryapi.dev/api/v2/entries/en/",
        },
        wikipedia = {
          enabled = true,
          api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/",
        },
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
3. A Telescope picker will open showing results from dictionary and Wikipedia
4. Navigate through results using Telescope's normal navigation
5. Press `<Enter>` to select a result
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
  sources = {
    dictionary = {
      enabled = true,  -- Enable/disable dictionary lookups
      api_url = "https://api.dictionaryapi.dev/api/v2/entries/en/",
    },
    wikipedia = {
      enabled = true,  -- Enable/disable Wikipedia lookups
      api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/",
    },
  },
  keymaps = {
    lookup = "<leader>fl",  -- Keymap for visual mode lookup
  },
  footnote_format = "[^%d]: %s",  -- Format for footnote content
})
```

## License

MIT
