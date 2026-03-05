return {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = function()
        -- This replaces the deprecated .setup() call
        vim.g.live_server = {
            port = 5555,
            -- Add other options here if needed, like:
            -- wait = 1000,
            -- browser = "firefox"
        }
    end
}
