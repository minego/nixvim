{ ... }:

{
	# Return a string, embedded in an attrset in the form that nixvim expects
	# to ensure that it gets output in lua as a raw value.
	mkRaw = value: {
		__raw = value;
	};

	# Create a lua function, in the form that is expected by nixvim
	mkFunc = value: {
		__raw = "function() ${value} end";
	};

	# Helper to create an entry that is suitable to include in 'keymaps[]'
	#
	# Example:
	#	keymaps = [
	#		(key "<f5>" "function() ... end" [ "n" "i" ])
	#	];
	key = key: action: desc: mode: {
		key				= key;
		options.desc	= desc;
		lua				= true;
		mode			= mode;
		action			= (action.__raw or action);
	};


	# Helper to create an entry that is suitable to include in
	# 'plugins.which-key.registrations[]'
	#
	#	name		Human readable name
	#	prefix		Key binding prefix
	#	mode		A list of modes, defaults to [ "n" ]
	#	silent		If true then the binding should not print any messages
	#	cmd			A vim command to run
	#	func		A lua script to run (Ignored if cmd is set as well)
	#				Note: This will wrap the value with "function()" and "end"
	wk = { name, prefix ? null, mode ? null, silent ? false, cmd ? null, func ? null, ... }@args: {
		# The first unkeyed field is the actual function to call
		"__unkeyed.1"	= (
			args.cmd or {
				"__raw" = "function() ${func} end";
			}
		);

		# The second unkeyed field is the name/description
		"__unkeyed.2"	= name;

		silent			= silent;
	}
	// (if (prefix != null)
	then {
		prefix			= prefix;
	} else {})

	// (if (mode != null)
	then {
		mode			= mode;
	} else {})

	;
}
