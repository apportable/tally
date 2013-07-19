Tally
=====

Simple SLOC counter that displays a subtotal for each [supported language][1].

Installation
------------

    git clone git://github.com/craigbarnes/tally.git
    cd tally
    sudo make install

Usage
-----

Change to the directory you want to count and simply use the `tally`
command. By default, Tally will include every file in every subdirectory
below the current working directory. You can change this by specifying files
and/or directories as arguments on the command-line, for example:

    tally dir1/ file1.c file2.py

Paths starting with a dot character (e.g. `.git`) are excluded, unless
specifically added.

Note: No output is displayed until all scanning and counting is complete, so
it may seem unresponsive for a few seconds, depending on the size and number
of files to be scanned.

tally.lua
---------

`tally.lua` is a re-implementation of Tally in Lua, intended to eventually
replace `tally.bash`. It should be considerably faster, especially when
dealing with a large number of files.

##### Dependencies

* [lfs]
* [LPeg]

##### Installation

    sudo make install TALLY=tally.lua

##### Usage

Usage is similar to `tally.bash`, although it can currently only accept
directories on the command line (not individual files). Totals will also
differ slightly from `tally.bash` because one excludes lines only containing
closing braces while the other includes them.

[License]
---------

Copyright (c) 2012-2013 Craig Barnes

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


[1]: https://github.com/craigbarnes/tally/blob/master/tally.bash#L49-74
[lfs]: http://keplerproject.github.io/luafilesystem/ "LuaFileSystem"
[LPeg]: http://www.inf.puc-rio.br/~roberto/lpeg/
[License]: http://en.wikipedia.org/wiki/ISC_license "ISC license"
