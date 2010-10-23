if has("ruby")

" ====================================================================================
" COPIED FROM FUZZYFINDER.VIM {{{
" since they can't be called from outside fuzzyfinder.vim
" ====================================================================================

function! s:ExistsPrompt(line, prompt)
  return  strlen(a:line) >= strlen(a:prompt) && a:line[:strlen(a:prompt) -1] ==# a:prompt
endfunction

function! s:RemovePrompt(line, prompt)
  return a:line[(s:ExistsPrompt(a:line, a:prompt) ? strlen(a:prompt) : 0):]
endfunction

" ------------------------------------------------------------------------------------
" }}}
" ====================================================================================

command! -bang -narg=? -complete=file   FuzzyFinderTextMate   call FuzzyFinderTextMateLauncher(<q-args>, len(<q-bang>))
command! FuzzyFinderTextMateRefreshFiles ruby refresh_finder
  
function! InstantiateTextMateMode() "{{{
ruby << RUBY
  begin
    require "#{ENV['HOME']}/.vim/ruby/fuzzy_file_finder"
  rescue LoadError
    begin
      require 'rubygems'
      begin
        gem 'fuzzy_file_finder'
      rescue Gem::LoadError
        gem 'jamis-fuzzy_file_finder'
      end
    rescue LoadError
    end

    require 'fuzzy_file_finder'
  end
RUBY

  " Configuration option: g:fuzzy_roots
  " Specifies roots in which the FuzzyFinder will search.
  if !exists('g:fuzzy_roots')
    let g:fuzzy_roots = ['.']
  endif

  " Configuration option: g:fuzzy_ceiling
  " Specifies the maximum number of files that FuzzyFinder allows to be searched
  if !exists('g:fuzzy_ceiling')
    let g:fuzzy_ceiling = 10000
  endif

  " Configuration option: g:fuzzy_ignore
  " A delimited list of file glob patterns to ignore. Entries may be delimited
  " with either commas or semi-colons.
  if !exists('g:fuzzy_ignore')
    let g:fuzzy_ignore = ""
  endif

  " Configuration option: g:fuzzy_path_display
  " Set to `abbr` if you want to display the abbreviated path to a file,
  " `full` to display the full path
  if !exists('g:fuzzy_path_display')
    let g:fuzzy_path_display = 'abbr'
  endif

  " Configuration option: g:fuzzy_enumerating_limit
  " The maximum number of matches to return at a time. Defaults to 200, via the
  " g:FuzzyFinderMode.TextMate.enumerating_limit variable, but using a global variable
  " makes it easier to set this value.

ruby << RUBY
  def finder
    @finder ||= begin
      roots = VIM.evaluate("g:fuzzy_roots").split("\n")
      ceiling = VIM.evaluate("g:fuzzy_ceiling").to_i
      ignore = VIM.evaluate("g:fuzzy_ignore").split(/[;,]/)
      FuzzyFileFinder.new(roots, ceiling, ignore)
    end
  end

  def refresh_finder
    @finder = nil
    finder
    nil
  end
RUBY

  let g:FuzzyFinderMode.TextMate = copy(g:FuzzyFinderMode.Base)

  function! g:FuzzyFinderMode.TextMate.on_complete(base)
    if exists('g:fuzzy_enumerating_limit')
      let l:enumerating_limit = g:fuzzy_enumerating_limit
    else
      let l:enumerating_limit = self.enumerating_limit
    endif
    let result = []
    ruby << RUBY

      text = VIM.evaluate('s:RemovePrompt(a:base,self.prompt)')
      enumerating_limit = VIM.evaluate('l:enumerating_limit').to_i
      path_display = VIM.evaluate("g:fuzzy_path_display")
      ceiling = VIM.evaluate('g:fuzzy_ceiling').to_i

      matches = finder.find(text, ceiling)
      matches_length = matches.length
      matches.sort_by { |a| [-a[:score], a[:path]] }[0,enumerating_limit].each_with_index do |match, index|
        word = match[:path]
        abbr = "%2d: %s" % [index+1, match[path_display.to_sym]]
        menu = "[%5d]" % [match[:score] * 10000]
        VIM.evaluate("add(result, { 'word' : fnamemodify(#{word.inspect},':~:.'), 'abbr' : #{abbr.inspect}, 'menu' : #{menu.inspect}, 'ranks': [#{index}] })")
      end
RUBY
    return result
  endfunction

  function! FuzzyFinderTextMateLauncher(initial_text, partial_matching)
    call g:FuzzyFinderMode.TextMate.launch(a:initial_text, a:partial_matching)
  endfunction
  
  let g:FuzzyFinderOptions.TextMate = copy(g:FuzzyFinderOptions.File)
endfunction "}}}

if !exists('loaded_fuzzyfinder') "{{{
  function! FuzzyFinderTextMateLauncher(initial_text, partial_matching)
    call InstantiateTextMateMode()
    function! FuzzyFinderTextMateLauncher(initial_text, partial_matching)
      call g:FuzzyFinderMode.TextMate.launch(a:initial_text, a:partial_matching)
    endfunction
    call g:FuzzyFinderMode.TextMate.launch(a:initial_text, a:partial_matching)
  endfunction
  finish
end "}}}

call InstantiateTextMateMode()

endif
