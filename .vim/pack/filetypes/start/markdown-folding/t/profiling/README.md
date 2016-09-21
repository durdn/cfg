# Performance profiling

To profile the performance of the `markdown-folding` script, run this:

    cd test/profiling
    ./MarkdownFolding-file.runner

That generates a file called `MarkdownFolding-file.result`, which includes detailed information about each function, such as this:

    FUNCTION  IsFenced()
    Called 289 times
    Total time:   1.207841
     Self time:   1.207841

    count  total (s)   self (s)
      289              0.001520   let cursorPosition = [line("."), col(".")]
      289              0.000900   call cursor(a:lnum, 1)
      289              0.000636   let startFence = '\%^```\|^\n\zs```'
      289              0.000508   let endFence = '```\n^$'
      289              1.201369   let fenceEndPosition = searchpairpos(startFence,'',endFence,'W')
      289              0.001346   call cursor(cursorPosition)
      289              0.000879   return fenceEndPosition != [0,0]

In this case, the performance bottleneck is the `searchpairpos()` invocation.
