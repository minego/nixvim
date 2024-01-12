{ inputs, pkgs, nixpkgs, ... }:

{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-xenon";
			src = inputs.nvim-xenon;
		})
	];

	imports = [
		./settings.nix
		./keybindings.nix

		./terminal.nix
		./ui.nix

		./treesitter.nix
		./telescope.nix
		./git.nix
		./dap.nix
		./lsp.nix
		./cmake.nix

# TODO Convert the rest of these
# go.lua
# rest.lua
# nvim-cmp
#
# - Why doesn't cmake debug work?
# - cspell is way too aggressive...
# - put it in git already

	];

	colorscheme					= "xenon";
	enableMan					= true;
	luaLoader.enable			= true;

	plugins.telescope.enable	= true;
	plugins.nvim-osc52.enable	= true;
	autoCmd = [
		{
			event			= ["TextYankPost"];
			callback		= { __raw = ''
				function()
					if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
						require('osc52').copy_register('+')
					end
				end
				'';
			};
		}
	];
}

