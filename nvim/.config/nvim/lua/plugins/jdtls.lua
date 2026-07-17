return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"saghen/blink.cmp",
		},
		config = function()
			local jdtls = require("jdtls")

			local function mason_package(name)
				return vim.fn.stdpath("data") .. "/mason/packages/" .. name
			end

			local function main_class(bufnr)
				local file = vim.api.nvim_buf_get_name(bufnr)
				local class = vim.fn.fnamemodify(file, ":t:r")
				for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 30, false)) do
					local package = line:match("^%s*package%s+([%w_.]+)%s*;")
					if package then
						return package .. "." .. class
					end
				end
				return class
			end

			local function start_jdtls()
				local bufnr = vim.api.nvim_get_current_buf()
				local root_markers = {
					"pom.xml",
					"mvnw",
					"gradlew",
					"settings.gradle",
					"settings.gradle.kts",
					"build.gradle",
					"build.gradle.kts",
					".git",
				}
				local root_dir = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

				for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "jdtls" })) do
					if client.config.root_dir == root_dir then
						return
					end
				end

				local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
				local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

				local jdtls_path = mason_package("jdtls")
				local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
				if launcher == "" then
					vim.notify("JDTLS não encontrado. Rode :MasonToolsInstall ou :MasonInstall jdtls", vim.log.levels.ERROR)
					return
				end

				local uname = vim.loop.os_uname().sysname
				local config_os = (uname == "Darwin" and "config_mac")
					or (uname == "Windows_NT" and "config_win")
					or "config_linux"
				local config_path = jdtls_path .. "/" .. config_os

				local bundles = {}
				local debug_jar = vim.fn.glob(mason_package("java-debug-adapter") .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
				if debug_jar ~= "" then
					table.insert(bundles, debug_jar)
				end
				vim.list_extend(
					bundles,
					vim.split(vim.fn.glob(mason_package("java-test") .. "/extension/server/*.jar"), "\n", { trimempty = true })
				)

				local cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					launcher,
					"-configuration",
					config_path,
					"-data",
					workspace_dir,
				}

				local on_attach = function(_, attached_bufnr)
					local opts = { noremap = true, silent = true, buffer = attached_bufnr }
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", function()
						local seen = {}
						vim.lsp.buf.code_action({
							filter = function(action)
								local key = action.title or ""
								if seen[key] then
									return false
								end
								seen[key] = true
								return true
							end,
						})
					end, opts)
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
					vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, opts)
					vim.keymap.set("v", "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
					vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)
					vim.keymap.set("n", "<leader>tn", jdtls.test_nearest_method, opts)
					vim.keymap.set("n", "<leader>re", function()
						require("jdtls.dap").setup_dap_main_class_configs()
						require("dap").continue()
					end, opts)

					jdtls.setup_dap({ hotcodereplace = "auto" })
					jdtls.setup.add_commands()

					vim.api.nvim_buf_create_user_command(attached_bufnr, "JavaBuild", function()
						local mvnw = vim.fs.find("mvnw", { path = root_dir, upward = false })[1]
						local pom = vim.fs.find("pom.xml", { path = root_dir, upward = false })[1]
						local gradlew = vim.fs.find("gradlew", { path = root_dir, upward = false })[1]
						local gradle = vim.fs.find({ "build.gradle", "build.gradle.kts" }, { path = root_dir, upward = false })[1]

						if mvnw then
							vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && ./mvnw compile")
						elseif pom then
							vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && mvn compile")
						elseif gradlew then
							vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && ./gradlew build")
						elseif gradle then
							vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && gradle build")
						else
							vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && mkdir -p out && javac -d out $(find . -name '*.java')")
						end
					end, {})

					vim.api.nvim_buf_create_user_command(attached_bufnr, "JavaRun", function()
						vim.cmd.terminal("cd " .. vim.fn.shellescape(root_dir) .. " && java -cp out " .. vim.fn.shellescape(main_class(attached_bufnr)))
					end, {})
				end

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				local ok_blink, blink = pcall(require, "blink.cmp")
				if ok_blink then
					capabilities = blink.get_lsp_capabilities(capabilities)
				end

				jdtls.start_or_attach({
					cmd = cmd,
					root_dir = root_dir,
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						java = {
							format = { enabled = true },
							completion = {
								favoriteStaticMembers = {
									"java.util.Objects.requireNonNull",
									"org.junit.jupiter.api.Assertions.*",
									"org.mockito.Mockito.*",
								},
								filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
							},
							configuration = { updateBuildConfiguration = "interactive" },
							contentProvider = { preferred = "fernflower" },
							inlayHints = { parameterNames = { enabled = "all" } },
							sources = {
								organizeImports = {
									starThreshold = 9999,
									staticStarThreshold = 9999,
								},
							},
						},
					},
					init_options = { bundles = bundles },
				})
			end

			local group = vim.api.nvim_create_augroup("user_jdtls", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "java",
				callback = start_jdtls,
			})

			start_jdtls()
		end,
	},
}
