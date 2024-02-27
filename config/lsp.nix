{ inputs, pkgs, nixpkgs, lib, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	extraConfigLuaPre = ''
		-- Create a client capabilities, so that we can override the
		-- offsetEncoding used by clangd. This is needed to make clangd and
		-- null-ls play nice together.
		local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
		clangd_capabilities.offsetEncoding = { "utf-16" }
	'';

	plugins.lsp = {
		enable							= true;

		servers = {
			clangd = {
				enable					= true;

				extraOptions = {
					capabilities		= util.mkRaw "clangd_capabilities";

					# This is needed so that 'cmake-tools' can tell the LSP
					# where to find compile_commands.json
					on_new_config		= util.mkRaw ''
						function(new_config, new_cwd)
							local status, cmake = pcall(require, "cmake-tools")
							if status then
								cmake.clangd_on_new_config(new_config)
							end
						end
					'';
				};
			};
			cmake.enable				= true;
			bashls.enable				= true;
			gopls.enable				= true;
			graphql.enable				= true;
			html.enable					= true;
			cssls.enable				= true;
			jsonls.enable				= true;
			yamlls.enable				= true;
			lua-ls.enable				= true;
			nixd.enable					= true;
			tsserver.enable				= true;
		};

		keymaps = {
			silent						= true;

			diagnostic = {
				"[d"					= "goto_prev";
				"]d"					= "goto_next";
				"<leader>q"				= "setloclist";
			};

			lspBuf = {
				"gD"					= "declaration";
				"gd"					= "definition";
				"K"						= "hover";
				"gi"					= "implementation";
				"<leader>rn"			= "rename";
				"<leader>ca"			= "code_action";
				"gr"					= "references";
			};
		};

		onAttach = ''
			local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

			-- Call require on each of these to make sure they are loaded after attach
			require('lsp_smag')
			require('lsp_signature').on_attach({
				bind = true,
			}, bufnr)

			-- This is used by ui.nix
			if client.server_capabilities.documentSymbolProvider then
				require('nvim-navic').attach(client, bufnr)
			end
		'';
	};

	plugins.lspkind.enable				= true;
	plugins.nvim-lightbulb.enable		= true;

	plugins.none-ls = {
		enable							= true;

		sources = {
			code_actions = {
				gitsigns.enable			= true;
				shellcheck.enable		= true;
				statix.enable			= true;
			};

			diagnostics = {
				cppcheck.enable			= true;
				deadnix.enable			= true;
				gitlint.enable			= true;
				golangci_lint.enable	= true;
				markdownlint.enable		= true;
				shellcheck.enable		= true;
				statix.enable			= true;
			};

			formatting = {
				trim_newlines.enable	= true;
				trim_whitespace.enable	= true;
				markdownlint.enable		= true;
				gofmt.enable			= true;
				golines.enable			= true;
				goimports.enable		= true;
				nixfmt.enable			= true;
			};
		};

		extraOptions.sources = [
			{ __raw = "require'null-ls'.builtins.diagnostics.codespell";	}
			{ __raw = "require'null-ls'.builtins.diagnostics.cmake_lint";	}
		];
	};

	# null-ls has support for codespell
	# the path.
	extraPackages = [
		pkgs.codespell
		pkgs.cmake-format
	];
}
