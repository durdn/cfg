if exists("b:did_ftplugin_go_install")
    finish
endif

if !exists('g:go_install_commands')
    let g:go_install_commands = 1
endif

if g:go_install_commands
    command! -buffer -nargs=? -complete=dir GoInstall call s:GoInstall(getcwd(), <f-args>)
    command! -buffer -nargs=? -complete=dir GoTest call s:GoTest(getcwd(), <f-args>)
    command! -buffer -nargs=? -complete=dir GoTestVerbose call s:GoTestVerbose(getcwd(), <f-args>)
endif

function! s:GoInstall(file, ...)
    if a:0 == 0
        " no arguments
        let relpkg = '.'
    else
        let relpkg = a:1
    endif
    let pkg=GoRelPkg(a:file, relpkg)
    if pkg != -1
        let output=system('go install '.pkg)
        if !v:shell_error
            echo 'Package '.pkg.' installed'
        else
            echo output
        endif
    else
        echohl Error | echo 'You are not in a go package' | echohl None
    endif
endfunction

function! s:GoTest(file, ...)
    if a:0 == 0
        " no arguments
        let relpkg = '.'
    else
        let relpkg = a:1
    endif
    let pkg=GoRelPkg(a:file, relpkg)
    if pkg != -1
        echo system('go test '.pkg)
    else
        echohl Error | echo 'You are not in a go package' | echohl None
    endif
endfunction

function! s:GoTestVerbose(file, ...)
    if a:0 == 0
        " no arguments
        let relpkg = '.'
    else
        let relpkg = a:1
    endif
    let pkg=GoRelPkg(a:file, relpkg)
    if pkg != -1
        echo system('go test -v '.pkg)
    else
        echohl Error | echo 'You are not in a go package' | echohl None
    endif
endfunction

let b:did_ftplugin_go_install=1

" vim:sw=4:et
