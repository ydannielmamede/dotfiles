 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#061538', -- Default Background
     base01 = '#0f2657', -- Lighter Background (status bars)
     base02 = '#0b2150', -- Selection Background
     base03 = '#5d6471', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#afb1b6', -- Dark Foreground (status bars)
     base05 = '#f2f2f3', -- Default Foreground
     base06 = '#f2f2f3', -- Light Foreground
     base07 = '#f2f2f3', -- Lightest Foreground
     -- Accent colors
     base08 = '#cc7092', -- Variables, XML Tags, Errors
     base09 = '#ce6e91', -- Integers, Constants
     base0A = '#8f79f2', -- Classes, Search Background
     base0B = '#799ff2', -- Strings, Diff Inserted
     base0C = '#e996b4', -- Regex, Escape Chars
     base0D = '#8bacf4', -- Functions, Methods
     base0E = '#9e8bf4', -- Keywords, Storage
     base0F = '#701a3a', -- Deprecated, Embedded Tags
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
