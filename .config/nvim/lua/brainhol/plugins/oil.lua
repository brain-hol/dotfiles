return {
	"stevearc/oil.nvim",
	config = function()
		vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
		require("oil").setup()
	end,
	opts = {},
}

