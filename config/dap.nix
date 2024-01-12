{ lib, inputs, pkgs, nixpkgs, ... }:

let
	util = import ./utils.nix {inherit lib;};

	f5			= util.mkFunc ''
		-- <F5> Start/Continue
		local cmake	= require('cmake-tools')
		local dap	= require('dap')

		require'dap.ext.vscode'.load_launchjs()
		if dap.session() == nil and cmake.is_cmake_project() then
			cmake.debug({})
		else
			dap.continue()
		end
		'';

	f17			= util.mkFunc ''
		-- <S-F5> Terminate
		require'dap'.terminate()
		require'dap'.close()
		require'nvim-dap-virtual-text'.refresh()

		require'dap'.repl.close()	
		require'dapui'.close()
		'';

	f9			= util.mkFunc "require'dap'.toggle_breakpoint()";
	f10			= util.mkFunc "require'dap'.step_over()";
	f11			= util.mkFunc "require'dap'.step_into()";
	f12			= util.mkFunc "require'dap'.step_out()";
	open_repl	= util.mkFunc "require'dap'.repl.open()";
	toggle_ui	= util.mkFunc "require'dapui'.toggle()";
	list_bps	= util.mkFunc "require'telescope'.extensions.dap.list_breakpoints{}";
	clear_bps	= util.mkFunc "require'dap'.clear_breakpoints()";
	cond_bp		= util.mkFunc "require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))()";
	debug_test	= util.mkFunc "require'dap-go'.debug_test()";
	backtrace	= util.mkFunc "require'telescope'.extensions.dap.frames{}";
	vars		= util.mkFunc "require'telescope'.extensions.dap.variables{}";
	view_var	= util.mkFunc "require'dap.ui.widgets'.preview()";
in
{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "nvim-telescope-dap";
			src = inputs.nvim-telescope-dap;
		})
		(pkgs.vimUtils.buildVimPlugin {
			name = "neotest";
			src = inputs.neotest;
		})
		(pkgs.vimUtils.buildVimPlugin {
			name = "neotest-go";
			src = inputs.neotest-go;
		})
	];

	# Define highlight groups for the signs below
	highlight = {
		DapBreakpoint = {
			fg			= "#993939";
			bg			= "#31353f";
		};

		DapLogPoint = {
			fg			= "#61afef";
			bg			= "#31353f";
		};

		DapStopped = {
			fg			= "#98c379";
			bg			= "#31353f";
		};
	};

	plugins.dap = {
		enable								= true;

		extensions.dap-ui = {
			enable							= true;
			expandLines						= true;

			layouts = [{
				elements					= [
					{ id = "scopes"; size = 0.25; }
					{ id = "stacks"; }
				];
				size						= 80; # 80 columns
				position					= "left";
			}];
		};

		extensions.dap-virtual-text = {
			enable							= true;

			# create commands DapVirtualTextEnable, DapVirtualTextDisable,
			# DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing
			# when debug adapter did not notify its termination)
			enabledCommands					= true;
			highlightChangedVariables		= true;
			highlightNewAsChanged			= true;
			showStopReason					= true;
			commented						= true;

			virtTextPos						= "eol";
			allFrames						= false;
			virtLines						= false;
			virtTextWinCol					= 80;
		};


		signs.dapStopped.linehl				= "DapStopped";
		signs.dapStopped.texthl				= "DapStopped";
		signs.dapStopped.numhl				= "DapStopped";
		signs.dapStopped.text				= "";

		signs.dapBreakpoint.linehl			= "DapBreakPoint";
		signs.dapBreakpoint.texthl			= "DapBreakPoint";
		signs.dapBreakpoint.numhl			= "DapBreakPoint";
		signs.dapBreakpoint.text			= "";

		signs.dapBreakpointCondition.linehl	= "DapBreakPoint";
		signs.dapBreakpointCondition.texthl	= "DapBreakPoint";
		signs.dapBreakpointCondition.numhl	= "DapBreakPoint";
		signs.dapBreakpointCondition.text	= "";

		signs.dapBreakpointRejected.linehl	= "DapBreakPoint";
		signs.dapBreakpointRejected.texthl	= "DapBreakPoint";
		signs.dapBreakpointRejected.numhl	= "DapBreakPoint";
		signs.dapBreakpointRejected.text	= "!";

		signs.dapLogPoint.linehl			= "DapLogPoint";
		signs.dapLogPoint.texthl			= "DapLogPoint";
		signs.dapLogPoint.numhl				= "DapLogPoint";
		signs.dapLogPoint.text				= "";
	};

	# Define these bindings in keymaps instead of which-key, since that makes
	# it easier to specify the modes.
	keymaps = [
		# NOTE: Shift adds 12 to the number for function keys

		(util.key "<f5>"  f5  "Debugger: Continue"			[ "n" "v" "i" ] )
		(util.key "<f17>" f17 "Debugger: Terminate"			[ "n" "v" "i" ] )
		(util.key "<f9>"  f9  "Debugger: Toggle Breakpoint"	[ "n" "v" "i" ] )
		(util.key "<f10>" f10 "Debugger: Step Over"			[ "n" "v" "i" ] )
		(util.key "<f11>" f11 "Debugger: Step Into"			[ "n" "v" "i" ] )
		(util.key "<f23>" f12 "Debugger: Step Out"			[ "n" "v" "i" ] )
		(util.key "<f12>" f12 "Debugger: Step Out"			[ "n" "v" "i" ] )
	];

	# Use which-key for grouped bindings
	plugins.which-key.registrations = {
		"<leader>d" = {
			name	= "Debugger";

			c		= [ f5			"(F5)    Continue"						];
			n		= [ f10			"(F10)   Next"							];
			s		= [ f11			"(F11)   Step"							];
			S		= [ f12			"(F12)   Finish"						];
			q		= [ f17			"(S-F5)  Terminate"						];

			b		= [ f9			"(F9)    Toggle Breakpoint"				];

			r		= [ open_repl	"Open REPL"								];
			u		= [ toggle_ui	"Toggle UI"								];
			X		= [ clear_bps	"Clear Breakpoint"						];
			C		= [ cond_bp		"Conditional Breakpoint"				];
			t		= [ debug_test	"Debug Test"							];

			k		= [ backtrace	"Backtrace"								];
			B		= [ list_bps	"List Breakpoints"						];
			v		= [ vars		"Variables"								];

			e		= [ ":vsplit .vscode/launch.json<CR>"
									"Edit launch.json"						];

			"<tab>"	= [ view_var	"View value under cursor"				];
		};
	};

	autoCmd = [
		{
			event			= [ "FileType" ];
			pattern			= [ "dap-repl" ];

			callback		= { __raw = ''
				function()
					-- Leave this off... It is annoying
					-- require('dap.ext.autocompl').attach()

					vim.wo.relativenumber	= false
					vim.wo.number			= false
					vim.o.signcolumn		= "no"

					vim.cmd([[ startinsert ]])
				end
				'';
			};
		}
	];

	# TODO Configurations
	# TODO Adapters

	extraConfigLua = ''
		local dap = require('dap')

		dap.adapters.lldb = {
			type	= 'executable',
			-- command	= 'lldb-vscode',
			command	= '${pkgs.lldb}/bin/lldb-vscode',
			name	= "lldb"
		}
		dap.adapters.c   = dap.adapters.lldb
		dap.adapters.cpp = dap.adapters.lldb

		dap.configurations.c = {
			{
				name = 'Attach to process',
				type = 'c',
				request = 'attach',
				pid = require('dap.utils').pick_process,
				args = {}
			},
			{
				name = 'Launch',
				type = 'c',
				request = 'launch',
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = "''${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				runInTerminal = false,
			},
		}

		-- This can be used for cpp and rust as well
		dap.configurations.cpp	= dap.configurations.c
		dap.configurations.objc	= dap.configurations.c
		dap.configurations.rust	= dap.configurations.c

		dap.listeners.after.event_initialized["my_config"] = function()
		  -- require('dapui').open()
			require('dap').repl.open()	
		end

		dap.listeners.after.event_terminated["my_config"] = function()
			require('dap').repl.close()	
			require('dapui').close()
		end
		dap.listeners.after.event_exited["my_config"] = function()
			require('dap').repl.close()	
			require('dapui').close()
		end

		require('telescope').load_extension('dap')

		require("neotest").setup({
			adapters = {
				require('neotest-go'),
			},
		})

		-- Run the current test
		vim.api.nvim_create_user_command('Test', function(opts)
			require("neotest").run.run()
		end, { nargs=0 })

		-- Run all tests in this file
		vim.api.nvim_create_user_command('TestFile', function(opts)
			require("neotest").run.run(vim.fn.expand("%")) 
		end, { nargs=0 })

		-- Run the current test in the debugger (with go)
		vim.api.nvim_create_user_command('TestDebugGo', function(opts)
			require('dap-go').debug_test()
		end, { nargs=0 })

		'';
}

