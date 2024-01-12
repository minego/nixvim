{ lib, inputs, pkgs, nixpkgs, ... }:

let
	util = import ./utils.nix {inherit lib;};
in
{
	extraConfigLuaPre = ''
		local domake = function(target)
			cmake = require("cmake-tools")

			if cmake.is_cmake_project() then
				if target == "clean" then
					vim.cmd([[ CMakeClean ]])
				elseif target == "all" then
					vim.cmd([[ CMakeBuild ]])
				elseif target == "clean all" then
					vim.cmd([[ CMakeBuild! ]])
				elseif target == "all install" then
					vim.cmd([[ CMakeInstall ]])
				elseif target == "clean all install" then
					vim.cmd([[ CMakeClean ]])
					vim.cmd([[ CMakeInstall ]])
				elseif target == "all test" then
					vim.cmd([[ CMakeRunTest ]])
				elseif target == "clean all test" then
					vim.cmd([[ CMakeClean ]])
					vim.cmd([[ CMakeRunTest ]])
				elseif target == "all debug" then
					vim.cmd([[ CMakeDebug ]])
				elseif target == "clean all debug" then
					vim.cmd([[ CMakeClean ]])
					vim.cmd([[ CMakeDebug ]])
				elseif target == "all run" then
					vim.cmd([[ CMakeRun ]])
				elseif target == "clean all run" then
					vim.cmd([[ CMakeClean ]])
					vim.cmd([[ CMakeRun ]])
				else
				end
			else
				vim.cmd("make " .. target)
			end
		end


	'';

	# Use which-key for bindings. Each module can set their own bindings in
	# 'plugins.which-key.registrations'
	plugins.which-key = {
		enable					= true;

		registrations = {
			# Open a terminal with ^Z
			"<c-z>" = [ "<cmd>botright vsplit | terminal<CR><C-L>"	"Open a Terminal"				];

			# Ignore F1 because it is too close to the escape key
			"<F1>" = {
				"__unkeyed.1"	= "<cmd><CR>";
				"__unkeyed.2"	= "Ignored";

				mode			= ["n" "v" "i" "t" "c" "x" "s" "o"];
				silent			= true;
			};

			# make
			"<leader>m" = {
				name	= "make";

				c		= util.wk { name = "make clean";				func = "domake(\"clean\")";				};
				C		= util.wk { name = "make clean";				func = "domake(\"clean\")";				};

				a		= util.wk { name = "make all";					func = "domake(\"all\")";				};
				A		= util.wk { name = "make clean all";			func = "domake(\"clean all\")";			};

				i		= util.wk { name = "make all install";			func = "domake(\"all install\")";		};
				I		= util.wk { name = "make clean all install";	func = "domake(\"clean all install\")";	};

				t		= util.wk { name = "make all test";				func = "domake(\"all test\")";			};
				T		= util.wk { name = "make clean all test";		func = "domake(\"clean all test\")";	};

				d		= util.wk { name = "make all debug";			func = "domake(\"all debug\")";			};
				D		= util.wk { name = "make clean all debug";		func = "domake(\"clean all debug\")";	};

				r		= util.wk { name = "make all run";				func = "domake(\"all run\")";			};
				R		= util.wk { name = "make clean all run";		func = "domake(\"clean all run\")";	};
			};

			# Change directory
			"<leader>" = {
				name	= "Change current directory";

				"cd"	= [ "<cmd>tcd %:p:h<CR>"				"Switch the current directory to that of the current file only for the current tab"		];
				"lcd"	= [ "<cmd>lcd %:p:h<CR>"				"Switch the current directory to that of the current file only for the current window"	];
			};

			# Quickfix
			"]q"		= [ "<cmd>cnext<cr>"					"Jump to next warning or error"		];
			"[q"		= [ "<cmd>cprev<cr>"					"Jump to prev warning or error"		];


			"<leader>w"	= [ "<cmd>wincmd w<CR>"					"Select next window"				];
			"<leader>W"	= [ "<cmd>wincmd W<CR>"					"Select prev window"				];

			# Split helpers
			"<leader>s"	= [ "<cmd>wincmd s<CR>"					":split"							];
			"<leader>v"	= [ "<cmd>wincmd v<CR>"					":vsplit"							];


			# Split/Edit helpers
			"<leader>S"	= util.wk{ name = ":split ...";			cmd = ":split  <C-R>=expand('%:p:h').'/'<CR>"; silent = false; };
			"<leader>V"	= util.wk{ name = ":vsplit ...";		cmd = ":vsplit <C-R>=expand('%:p:h').'/'<CR>"; silent = false; };
			"<leader>e"	= util.wk{ name = ":edit ...";			cmd = ":edit   <C-R>=expand('%:p:h').'/'<CR>"; silent = false; };

			# Terminal
			"<esc><esc>"= {
				"__unkeyed.1"	= "<c-\\><c-n>";
				"__unkeyed.2"	= "Escape with double escape";

				mode			= [ "t" ];
			};
			"<c-w>"		= {
				"__unkeyed.1"	= "<c-\\><c-n><c-w>";
				"__unkeyed.2"	= "Treat <c-w> like any other window";
				mode			= [ "t" ];
			};
		};
	};
}
