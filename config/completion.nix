{ lib, inputs, pkgs, nixpkgs, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	plugins.nvim-cmp = {
		enable										= true;
		sources = [
			{ name									= "path";			}
		];

		completion.autocomplete						= false;

		mapping = {
			"<C-Space>"								= "cmp.mapping.complete()";
			"<CR>"									= "cmp.mapping.confirm({ select = true })";

			"<C-e>"									= "cmp.mapping.close()";
			"<C-d>"									= "cmp.mapping.scroll_docs(-4)";
			"<C-f>"									= "cmp.mapping.scroll_docs(4)";

			"<S-Tab>" = {
				action								= "cmp.mapping.select_prev_item()";
				modes								= [ "i" "s" ];
			};
			"<Tab>" = {
				action								= "cmp.mapping.select_next_item()";
				modes								= [ "i" "s" ];
			};
		};
	};

	plugins.cmp-buffer.enable						= true;
	plugins.cmp-path.enable							= true;
	plugins.cmp-calc.enable							= true;
	plugins.cmp-cmdline.enable						= true;
	plugins.cmp-cmdline-history.enable				= true;
	plugins.cmp-dap.enable							= true;
	plugins.cmp-emoji.enable						= true;
	plugins.cmp-git.enable							= true;
	plugins.cmp-nvim-lsp.enable						= true;
	plugins.cmp-nvim-lsp-document-symbol.enable		= true;
	plugins.cmp-nvim-lsp-signature-help.enable		= true;
	plugins.cmp-treesitter.enable					= true;
}
