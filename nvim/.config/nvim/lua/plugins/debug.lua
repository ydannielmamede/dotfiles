return {

    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<F5>", dap.continue)
        vim.keymap.set("n", "<F10>", dap.step_over)
        vim.keymap.set("n", "<F1>", dap.step_into)
        vim.keymap.set("n", "<F2>", dap.step_out)

        vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<Leader>B", dap.set_breakpoint)

        vim.keymap.set("n", "<Leader>lp", function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end)

        vim.keymap.set("n", "<Leader>dr", dap.repl.open)
        vim.keymap.set("n", "<Leader>dl", dap.run_last)

        require("dap-vscode-js").setup({
            debugger_cmd = { "js-debug-adapter" },
            adapters = { "pwa-node", "pwa-chrome" },
        })

        local javascript_filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
        }

        for _, filetype in ipairs(javascript_filetypes) do
            dap.configurations[filetype] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch current file (Node)",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                    sourceMaps = true,
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach to Node process",
                    processId = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                    skipFiles = { "<node_internals>/**" },
                },
                {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Launch Chrome",
                    url = function()
                        return vim.fn.input("URL: ", "http://localhost:3000")
                    end,
                    webRoot = "${workspaceFolder}",
                    sourceMaps = true,
                },
            }
        end
    end,
}
