{ inputs, pkgs, nixpkgs, lib, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "cspell";
			src = inputs.cspell;
		})
	];

	plugins.lsp = {
		enable							= true;

		servers = {
			clangd = {
				enable					= true;

				extraOptions = {
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
			{ __raw = "require'cspell'.diagnostics";	}
			{ __raw = "require'cspell'.code_actions";	}
		];
	};

	# null-ls has support for codespell and cspell, but they need to be in
	# the path.
	extraPackages = [
		pkgs.nodePackages.cspell
		pkgs.codespell
	];
}
