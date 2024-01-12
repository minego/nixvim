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
#	- neotest
#	- neotest-go
#	- goimpl
#	- vim-go-coverage
#	- nvim-dap-go
# nvim-cmp
#
# - Why doesn't cmake debug work?
# - Review rest of config and make sure I'm not missing anything...
# - Look through other nixvim modules and possibly add more stuff?

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

