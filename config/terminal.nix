{ inputs, pkgs, nixpkgs, ... }:

{
	extraPlugins = [
		(pkgs.vimUtils.buildVimPlugin {
			name = "flatten";
			src = inputs.flatten;
		})
	];

	extraConfigLuaPre = ''
        -- Open man pages in neovim splits as well
        vim.cmd('let $MANPAGER="nvim +Man!"')  
        
        require("flatten").setup({
        	window = {
        		-- I prefer using 'alternate' but then closing the opened
        		-- window causes the whole tab to close...
        		--
        		-- Restore this option once I figure out a way to prevent
        		-- that happening...
        		-- open = "alternate",
        
        		open = "vsplit",
        		focus = "first",
        	},
        })
        '';
}
