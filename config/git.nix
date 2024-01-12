{ inputs, pkgs, nixpkgs, ... }:

{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "fugitive-gitlab";
			src = inputs.fugitive-gitlab;
		})
	];

	plugins.gitsigns = {
		enable					= true;
		signcolumn				= true;
	};

	plugins.neogit = {
		enable					= true;
	};

	plugins.diffview = {
		enable					= true;
	};

	plugins.fugitive = {
		enable					= true;
	};

	plugins.which-key.registrations = {
		"<leader>g" = {
			name				= "Git";

			s = [ ":Neogit<CR>"					"git status"			];
			S = [ ":Telescope git_status<CR>"	"git status (telescope)"];
			p = [ ":G pull<CR>"					"git pull"				];
			P = [ ":G push<CR>"					"git push"				];
			d = [ ":Gdiffsplit<CR>"				"git diff (split)"		];
			b = [ ":G blame<CR>"				"git blame"				];
			l = [ ":Gclog<CR>"					"git log"				];
			r = [ ":Gread<CR>"					"git checkout --"		];
			a = [ ":Gwrite<CR>"					"git add"				];
			B = [ ":GBrowse<CR>"				"Open in browser"		];
			h = [ ":Telescope git_bcommits<CR>" "git commit history for this buffer"];
			H = [ ":Telescope git_commits<CR>"	"git commit history for all files"];
		};
	};
}
