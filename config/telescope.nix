{ inputs, pkgs, nixpkgs, lib, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-telescope-emoji";
			src = inputs.nvim-telescope-emoji;
		})
	];

	extraConfigLua = ''
		require('telescope').load_extension('emoji')
	'';


	plugins.which-key.registrations = {
		"<leader>f" = {
			name	= "find files";

			f		= util.wk { name = "find files";			cmd = "<cmd>Telescope find_files<CR>";				};
			g		= util.wk { name = "live grep";				cmd = "<cmd>Telescope live_grep<CR>";				};
			b		= util.wk { name = "buffers";				cmd = "<cmd>Telescope buffers<CR>";					};
			h		= util.wk { name = "help";					cmd = "<cmd>Telescope help_tags<CR>";				};
			G		= util.wk { name = "git files";				cmd = "<cmd>Telescope git_files<CR>";				};
			r		= util.wk { name = "LSP references";		cmd = "<cmd>Telescope lsp_references<CR>";			};
			i		= util.wk { name = "LSP implementations";	cmd = "<cmd>Telescope lsp_implementations<CR>";		};
			o		= util.wk { name = "LSP document symbols";	cmd = "<cmd>Telescope lsp_document_symbols<CR>";	};
			D		= util.wk { name = "LSP definitions";		cmd = "<cmd>Telescope lsp_definitions<CR>";			};
			d		= util.wk { name = "diagnostics";			cmd = "<cmd>Telescope diagnostics<CR>";				};
			q		= util.wk { name = "quickfix";				cmd = "<cmd>Telescope quickfix<CR>";				};
			s		= util.wk { name = "git stash";				cmd = "<cmd>Telescope git_stash<CR>";				};
			B		= util.wk { name = "git branches";			cmd = "<cmd>Telescope git_branches<CR>";			};
			m		= util.wk { name = "man pages";				cmd = "<cmd>Telescope man_pages<CR>";				};

			e		= util.wk { name = "emoji";					cmd = "<cmd>Telescope emoji<CR>";					};
		};

		"<c-k>"		= util.wk { name = "Find Buffers";			cmd = "<cmd>Telescope buffers<CR>";					};

		# Disable this, because I like the one built into which-key more
		# "z="		= util.wk { name = "Spelling Suggestions";	cmd = "<cmd>Telescope spell_suggest<CR>";			};
	};
}
