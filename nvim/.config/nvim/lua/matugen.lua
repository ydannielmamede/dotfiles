 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#111412', -- Default Background
     base01 = '#1d201e', -- Lighter Background (status bars)
     base02 = '#272b28', -- Selection Background
     base03 = '#8a938c', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#c0c9c1', -- Dark Foreground (status bars)
     base05 = '#e1e3df', -- Default Foreground
     base06 = '#e1e3df', -- Light Foreground
     base07 = '#e1e3df', -- Lightest Foreground
     -- Accent colors
     base08 = '#ffb4ab', -- Variables, XML Tags, Errors
     base09 = '#a4cddd', -- Integers, Constants
     base0A = '#b4ccbc', -- Classes, Search Background
     base0B = '#70dba7', -- Strings, Diff Inserted
     base0C = '#a4cddd', -- Regex, Escape Chars
     base0D = '#70dba7', -- Functions, Methods
     base0E = '#b4ccbc', -- Keywords, Storage
     base0F = '#93000a', -- Deprecated, Embedded Tags
   }
 end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
