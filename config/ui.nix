{ inputs, pkgs, nixpkgs, lib, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-web-devicons";
			src = inputs.nvim-web-devicons;
		})
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-scope";
			src = inputs.nvim-scope;
		})
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-telescope-tabs";
			src = inputs.nvim-telescope-tabs;
		})
	];

	plugins.lualine = {
		enable							= true;
		globalstatus					= true;

		sections = {
			lualine_a = [
				{
					name				= "mode";
					extraConfig = {
						fmt				= util.mkRaw "function(str) return str:sub(1,1) end";
					};
				}
			];

			lualine_b = [
				{
					name				= "branch";
					extraConfig = {
						on_click		= util.mkRaw "function() require('telescope.builtin').git_branches() end";
					};
				}
				"diff"
				{
					name				= "diagnostics";
					extraConfig = {
						on_click		= util.mkRaw "function() require('telescope.builtin').diagnostics() end";
					};
				}	
			];

			lualine_c = [
				{
					name				= "filename";
					extraConfig = {
						on_click		= util.mkRaw "function() require('telescope.builtin').buffers() end";
					};
				}	
				{
					name				= "codecontext";
					extraConfig = {
						on_click		= util.mkRaw "function() require('telescope.builtin').lsp_document_symbols() end";
					};
				}	
			];

			lualine_x = [
				"encoding" "fileformat"
				{
					name				= "filetype";
					extraConfig = {
						colored			= false;
					};
				}	
			];
			lualine_y = [
				"progress"
			];
			lualine_z = [
				"location"
			];
		};

		tabline = {
			lualine_a = [
				{
					name				= util.mkRaw "function() return [[=]] end";
					extraConfig = {
	 					on_click		= util.mkRaw "function() require('telescope-tabs').list_tabs() end";
					};
				}
			];

			lualine_b = [
				{
					name				= "tabs";
					extraConfig = {
						mode			= 2; # Show number and name
						max_length		= 1000;
						tabs_color = {
							active		= "TabLine";
							inactive	= "TabLineSel";
						};
					};
				}
			];

			lualine_z = [
				"hostname"
			];
		};
	};

	plugins.which-key.registrations = {
		"tabs" = {
			name	= "Tabs";

			prefix	= "<C-a>";
			mode	= ["n" "v" "i" "t" "c" "x" "s" "o"];

			"<tab>"	= util.wk { name = "list";				func = "require('telescope-tabs').list_tabs()"; };
			"a"		= util.wk { name = "toggle";			cmd = "<c-\\><c-n>g<tab>";			};
			"<C-a>"	= util.wk { name = "toggle";			cmd = "<c-\\><c-n>g<tab>";			};

			# The $ in '$tabnew' causes it to be created at the end.
			# The global working dir is returned with 'getcwd(-1, -1)' and
			# that needs to be set for each new tab or it will have the
			# working directory of the tab that created it.
			C		= util.wk { name = "create";			cmd = "<c-\\><c-n>:$tabnew<CR>:call chdir(getcwd(-1, -1))<CR>"; };
			c		= util.wk { name = "create terminal";	cmd = "<c-\\><c-n>:$tabnew<CR>:call chdir(getcwd(-1, -1))<CR>:term<CR>"; };

			x		= util.wk { name = "close";				cmd = "<c-\\><c-n>:tabclose<CR>";	};
			n		= util.wk { name = "next";				cmd = "<c-\\><c-n>:tabn<CR>";		};
			p		= util.wk { name = "prev";				cmd = "<c-\\><c-n>:tabp<CR>";		};
			N		= util.wk { name = "swap with next";	cmd = "<c-\\><c-n>:+tabmove<CR>";	};
			P		= util.wk { name = "swap with prev";	cmd = "<c-\\><c-n>:-tabmove<CR>";	};

			","		= util.wk { name = "rename";			cmd = "<c-\\><c-n>:LualineRenameTab "; silent = false; };

			"1"		= util.wk { name = "go to tab 1";		cmd = "<c-\\><c-n>1gt";				};
			"2"		= util.wk { name = "go to tab 2";		cmd = "<c-\\><c-n>2gt";				};
			"3"		= util.wk { name = "go to tab 3";		cmd = "<c-\\><c-n>3gt";				};
			"4"		= util.wk { name = "go to tab 4";		cmd = "<c-\\><c-n>4gt";				};
			"5"		= util.wk { name = "go to tab 5";		cmd = "<c-\\><c-n>5gt";				};
			"6"		= util.wk { name = "go to tab 6";		cmd = "<c-\\><c-n>6gt";				};
			"7"		= util.wk { name = "go to tab 7";		cmd = "<c-\\><c-n>7gt";				};
			"8"		= util.wk { name = "go to tab 8";		cmd = "<c-\\><c-n>8gt";				};
			"9"		= util.wk { name = "go to tab 9";		cmd = "<c-\\><c-n>9gt";				};
			"0"		= util.wk { name = "go to tab 0";		cmd = "<c-\\><c-n>10gt";			};
		};
	};

	plugins.navic = {
		enable							= true;
		click							= true;
		separator						= " > ";
		depthLimit						= 0;
		safeOutput						= true;
	};

	plugins.indent-blankline = {
		enable							= true;
	};


	extraConfigLua = ''
		-- Make buffer scoped to tabs
		require('scope').setup()
	'';
}

