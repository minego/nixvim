{ inputs, pkgs, nixpkgs, lib, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	plugins.treesitter = {
		enable					= true;
		nixGrammars				= false;
		ensureInstalled			= [];
		folding					= false;
		indent					= false;
		nixvimInjections		= true;
		package					= pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

		incrementalSelection = {
			enable				= true;
		};
	};

	plugins.rainbow-delimiters = {
		enable					= false;
	};

	plugins.treesitter-context = {
		enable					= true;
	};

	plugins.ts-autotag = {
		enable					= true;
	};

	plugins.ts-context-commentstring = {
		enable					= true;
	};

	plugins.treesitter-textobjects = {
		enable					= true;

		move = {
			enable				= true;

			gotoNextStart = {
				"]m"			= "@function.outer";
				"]]"			= "@function.outer";
			};
			gotoNextEnd = {
				"]M"			= "@function.outer";
				"]["			= "@function.outer";
			};
			gotoPreviousStart = {
				"[m"			= "@function.outer";
				"[["			= "@function.outer";
			};
			gotoPreviousEnd = {
				"[M"			= "@function.outer";
				"[]"			= "@function.outer";
			};
		};
	};

	extraConfigVim = ''
		hi link TreesitterContext StatusLine
	'';
}
