-- Search by text
nnoremap('<c-f>', ':Find<CR>')
-- Search by file name (directory of vim)
nnoremap('<c-j>', ':Files<CR>')
-- Access Buffer list
nnoremap('<c-b>', ':Buffer<CR>')

-- CONFIGURE FIND SEARCH FOR FILES
 --column: Show column number
 --line-number: Show line number
 --no-heading: Do not show file headings in results
 --fixed-strings: Search term as a literal string
 --ignore-case: Case insensitive search
 --no-ignore: Do not respect .gitignore, etc...
 --hidden: Search hidden files and folders
 --follow: Follow symlinks
 --glob: Additional conditions for search (in this case ignore everything in the .git,yarn.lock,etc.)
 --color: Search color options
 --delimiter : --nth 4... Ensures that we only search content, not filename

-- This is the equivalent of calling :FZF vimgrep rg ....
vim.cmd [[ command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow -g "!{yarn.lock,package-lock.json,public,node_modules,.git,yarn-error.log,yarn.lock,dist,build,.cache}" --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..', 'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2]}), <bang>0) ]]
