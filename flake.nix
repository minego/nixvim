{
	description = "minego's nixvim configuration";

	inputs = {
		nixpkgs.url					= "github:nixos/nixpkgs/nixos-unstable";

		nixvim.url					= "github:nix-community/nixvim";

		flake-utils.url				= "github:numtide/flake-utils";

		nvim-xenon					= { url = "github:minego/nvim-xenon";							flake = false; };
		nvim-telescope-emoji		= { url = "github:xiyaowong/telescope-emoji.nvim";				flake = false; };
		nvim-telescope-dap			= { url = "github:nvim-telescope/telescope-dap.nvim";			flake = false; };
		nvim-telescope-tabs			= { url = "github:LukasPietzschmann/telescope-tabs";			flake = false; };
		nvim-dap-virtual-text		= { url = "github:theHamsta/nvim-dap-virtual-text";				flake = false; };

		fugitive-gitlab				= { url = "github:shumphrey/fugitive-gitlab.vim";				flake = false; };
		flatten						= { url = "github:willothy/flatten.nvim";						flake = false; };

		neotest						= { url = "github:nvim-neotest/neotest";						flake = false; };
		neotest-go					= { url = "github:nvim-neotest/neotest-go";						flake = false; };

		nvim-scope					= { url = "github:tiagovla/scope.nvim";							flake = false; };
		nvim-web-devicons			= { url = "github:kyazdani42/nvim-web-devicons";				flake = false; };

		cspell						= { url = "github:davidmh/cspell.nvim";							flake = false; };

		cmake-tools					= { url = "github:Civitasv/cmake-tools.nvim";					flake = false; };
		nvim-notify					= { url = "github:rcarriga/nvim-notify";						flake = false; };
	};

	outputs = { self, nixpkgs, nixvim, flake-utils, ... } @inputs:

	flake-utils.lib.eachDefaultSystem (system:
		let
			pkgs		= nixpkgs.legacyPackages.${system};
			nixvimLib	= nixvim.lib.${system};
			nixvim'		= nixvim.legacyPackages.${system};
			nvim		= nixvim'.makeNixvimWithModule {
				inherit pkgs;

				module = import ./config { inherit pkgs inputs; };

				extraSpecialArgs = { inherit pkgs inputs; };
			};
		in {
			checks = {
				# Run `nix flake check .` to verify that your
				# config is not broken.
				default = nixvimLib.check.mkTestDerivationFromNvim {
					inherit nvim;

					name = "minego's nixvim configuration";
				};
			};

			packages = {
				# Lets you run `nix run .` to start nixvim
				default = nvim;
			};
		}
	) // {
		overlays.default = final: prev: {
			# Replace the 'neovim' in nixpkgs with our own
			neovim					= self.packages.${prev.system}.default;
		};
	};
}

