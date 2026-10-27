return {
	"karb94/neoscroll.nvim",
	event = "VeryLazy",
	config = function()
		local neoscroll = require("neoscroll")
		neoscroll.setup({
			stop_eof = true,
			hide_cursor = true,
		})

		local scroll_keys = {
			["<C-b>"] = function() neoscroll.ctrl_b({ duration = 200 }) end,
			["<C-f>"] = function() neoscroll.ctrl_f({ duration = 200 }) end,
			["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 60 }) end,
			["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 60 }) end,
			["zt"] = function() neoscroll.zt({ half_win_duration = 100 }) end,
			["zz"] = function() neoscroll.zz({ half_win_duration = 100 }) end,
			["zb"] = function() neoscroll.zb({ half_win_duration = 100 }) end,
		}

		for k, f in pairs(scroll_keys) do
			vim.keymap.set({ "n", "v", "x" }, k, f)
		end
	end,
}
