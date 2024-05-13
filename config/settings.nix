{ lib, inputs, pkgs, nixpkgs, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	config = {
		globals = {
			mapleader			= "\\";

			# Improve the file browser
			netrw_banner		= false;
			netrw_altv			= true; # open splits to the right
			netrw_preview		= true; # preview split to the right
			netrw_liststyle		= 3;	# tree view
		};

		opts = {
			swapfile			= false;
			ruler				= true;
			background			= "dark";

			# Hide the mode, since it is shown in lualine
			showmode			= false;

			# Do NOT unload hidden buffers
			hidden				= false;

			# Always show the signcolumn (This has other options, so it isn't a bool)
			signcolumn			= "yes";

			# If a buffer is open in another tab, switch to that instead of
			#polluting the current tab
			switchbuf			= "usetab,uselast";

			visualbell			= true; # I'd prefer a flash over a beep
			wildmenu			= true;
			wildmode			= "list:longest";

			hlsearch			= true;
			incsearch			= true;

			smartcase			= true;
			ignorecase			= true;
			title				= true;
			scrolloff			= 10;
			sidescrolloff		= 10;
			sidescroll			= 1;
			laststatus			= 3; # Display a single status bar for all windows

			number				= false;
			wrap				= false;

			foldenable			= false;

			textwidth			= 80;
			colorcolumn			= "80";
			termguicolors		= true;

			completeopt			= "menuone,longest,noselect,preview";

			wildignore			= "*.swp,*.o,*.la,*.lo,*.a";
			suffixes			= "*.swp,*.o,*.la,*.lo,*.a";
		};

		autoCmd = [
			# I despise auto formatting, auto indent, etc.
			#
			# Whenever opening any file, regardless of what plugins may do,
			# turn that shit off!
			{
				event			= ["BufNewFile" "BufRead" "BufEnter" "BufWinEnter" "FileType" ];
				pattern			= [ "*" ];

				callback		= util.mkRaw ''
					function()
						vim.bo.autoindent		= false
						vim.bo.smartindent		= false
						vim.bo.cindent			= false
						vim.bo.indentexpr		= ""
						vim.bo.formatoptions	= ""

						vim.bo.autoread			= true
						vim.bo.expandtab		= false

						vim.bo.tabstop			= 4		-- Tabs are 4 wide - I'm not a monster!
						vim.bo.softtabstop		= 4
						vim.bo.shiftwidth		= 4
					end
                    '';
			}

			# Auto reload contents of a buffer
			{
				event			= [ "FocusGained" "BufEnter" "CursorHold" "CursorHoldI" ];
				pattern			= [ "*" ];
				callback		= util.mkRaw ''
					function()
						vim.api.nvim_command('checktime')
					end
                    '';
			}

			# Show relative numbers in the active window, and absolute in others
			{
				event			= [ "WinLeave" ];
				pattern			= [ "*" ];
				callback		= util.mkRaw ''
					function()
						vim.wo.relativenumber	= false
						vim.wo.number			= true
						vim.wo.numberwidth		= 5
					end
                    '';
			}
			{
				event			= [ "BufEnter" "WinEnter" ];
				pattern			= [ "*" ];
				callback		= util.mkRaw ''
					function()
						vim.wo.relativenumber	= true
						vim.wo.number			= true
						vim.wo.numberwidth		= 5
					end
                    '';
			}

			# Show crosshairs but only in the active window
			{
				event			= [ "WinLeave" ];
				pattern			= [ "*" ];
				callback		= util.mkRaw ''
					function()
						vim.wo.cursorline		= false
						vim.wo.cursorcolumn		= false
						vim.o.signcolumn		= "no"
					end
                    '';
			}
			{
				event			= [ "BufEnter" "WinEnter" ];
				pattern			= [ "*" ];
				callback		= util.mkRaw ''
					function()
						vim.wo.cursorline		= true
						vim.wo.cursorcolumn		= true
						vim.o.signcolumn		= "yes"
					end
                    '';
			}

			# Help me spell
			{
				event			= [ "BufNewFile" "BufRead" ];
				pattern			= [ "*.txt" "*.md" ];
				callback		= util.mkRaw ''
					function()
						vim.opt_local.spell		= true
						vim.opt_local.wrap		= true
					end
                    '';
			}
			{
				event			= [ "BufNewFile" "BufRead" ];
				pattern			= [ "*.cmake" "CmakeLists.txt" ];
				callback		= util.mkRaw ''
					function()
						vim.opt_local.spell		= false
						vim.opt_local.wrap		= false
					end
                    '';
			}

			# I resize my terminal frequently
			{
				event			= [ "VimResized" ];
				pattern			= [ "*" ];
				command			= "wincmd =";
			}

			# Terminal
			{
				event			= [ "TermOpen" "TermEnter" "BufEnter" ];
				pattern			= [ "term://*" ];
				callback		= util.mkRaw ''
					function()
						vim.wo.relativenumber	= false
						vim.wo.number			= false
						vim.o.signcolumn		= "no"

						vim.cmd([[ startinsert ]])
					end
                    '';
			}
		];
	};
}
