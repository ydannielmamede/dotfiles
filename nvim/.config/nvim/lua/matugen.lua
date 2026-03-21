 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#03123a', -- Default Background
     base01 = '#0f2357', -- Lighter Background (status bars)
     base02 = '#0b1f50', -- Selection Background
     base03 = '#5d6371', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#afb1b6', -- Dark Foreground (status bars)
     base05 = '#f2f2f3', -- Default Foreground
     base06 = '#f2f2f3', -- Light Foreground
     base07 = '#f2f2f3', -- Lightest Foreground
     -- Accent colors
     base08 = '#fd4663', -- Variables, XML Tags, Errors
     base09 = '#c436fc', -- Integers, Constants
     base0A = '#6136fc', -- Classes, Search Background
     base0B = '#4f80fc', -- Strings, Diff Inserted
     base0C = '#da81fd', -- Regex, Escape Chars
     base0D = '#82a5fd', -- Functions, Methods
     base0E = '#9c81fd', -- Keywords, Storage
     base0F = '#900017', -- Deprecated, Embedded Tags
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
