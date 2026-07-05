return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		config = function()
			local jdtls = require("jdtls")

			local function start_jdtls()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.keymap.set("n", "<leader>jg", function()
					vim.lsp.buf.code_action({ context = { only = { "source" } } })
				end, { noremap = true, silent = true, buffer = bufnr })

				local root_markers = { "pom.xml", "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git" }
				local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()
				local workspace_dir = vim.fn.stdpath("data")
					.. "/jdtls-workspaces/"
					.. vim.fn.fnamemodify(root_dir, ":p:t")

				local mason_path = vim.fn.stdpath("data") .. "/mason"
				local jdtls_path = mason_path .. "/packages/jdtls"
				local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

				local uname = vim.loop.os_uname().sysname
				local config_os = (uname == "Darwin" and "config_mac")
					or (uname == "Windows_NT" and "config_win")
					or "config_linux"
				local config_path = jdtls_path .. "/" .. config_os
				local bundles = {}

				local debug_jar = vim.fn.glob(
					mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
				)
				if debug_jar ~= "" then
					table.insert(bundles, debug_jar)
				end

				vim.list_extend(
					bundles,
					vim.split(
						vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar"),
						"\n",
						{ trimempty = true }
					)
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

				local on_attach = function(_, bufnr)
					local opts = { noremap = true, silent = true, buffer = bufnr }
					-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
					vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)

					vim.keymap.set("n", "<leader>re", function()
						require("jdtls.dap").setup_dap_main_class_configs()
						require("dap").continue()
					end, opts)

					-- Seu atalho (code action "source")

					jdtls.setup_dap({ hotcodereplace = "auto" })
					jdtls.setup.add_commands()

					local function main_class()
						local file = vim.api.nvim_buf_get_name(bufnr)
						local class = vim.fn.fnamemodify(file, ":t:r")
						for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)) do
							local package = line:match("^%s*package%s+([%w_.]+)%s*;")
							if package then
								return package .. "." .. class
							end
						end
						return class
					end

					-- Comandos buffer-locais para build/run
					vim.api.nvim_buf_create_user_command(bufnr, "JavaBuild", function()
						vim.fn.jobstart({ "bash", "-lc", "shopt -s globstar nullglob; mkdir -p out && javac -d out src/**/*.java *.java" }, {
							cwd = root_dir,
							stdout_buffered = true,
							stderr_buffered = true,
						})
					end, {})

					vim.api.nvim_buf_create_user_command(bufnr, "JavaRun", function()
						vim.fn.jobstart({ "java", "-cp", "out", main_class() }, { cwd = root_dir, stdout_buffered = true })
					end, {})
				end

				local capabilities = vim.lsp.protocol.make_client_capabilities()

				local settings = {
					java = {
						format = { enabled = true },
						completion = {
							favoriteStaticMembers = {
								"java.util.Objects.requireNonNull",
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
						},
						configuration = {
							updateBuildConfiguration = "interactive",
						},
						project = { referencedLibraries = {} },
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						contentProvider = { preferred = "fernflower" },
						inlayHints = {
							parameterNames = { enabled = "all" },
						},
					},
				}

				jdtls.start_or_attach({
					cmd = cmd,
					root_dir = root_dir,
					on_attach = on_attach,
					capabilities = capabilities,
					settings = settings,
					init_options = { bundles = bundles },
				})
			end

			start_jdtls()

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = start_jdtls,
			})
		end,
	},
}
