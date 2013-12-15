Tally
=====

A simple, command-line SLOC counter written in [Lua].

Requirements
------------

* [Lua] 5.1/5.2 or [LuaJIT] 2.x
* [LuaFileSystem]
* [LPeg]

Installation
------------

    git clone git://github.com/craigbarnes/tally.git
    cd tally
    sudo make install

Usage
-----

By default, running `tally` will count every file in every subdirectory
below the current working directory. You can change this by specifying files
and/or directories as arguments on the command-line, for example:

    tally dir1/ file1.c file2.py

Paths starting with a dot character (e.g. `.git`) are excluded, unless
specifically added.

License
-------

Copyright (C) 2012-2013 Craig Barnes

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU [General Public License version 3], as published
by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License version 3 for more details.


[Lua]: http://www.lua.org/
[LuaJIT]: http://luajit.org/
[LuaFileSystem]: http://keplerproject.github.io/luafilesystem/
[LPeg]: http://www.inf.puc-rio.br/~roberto/lpeg/
[General Public License version 3]: http://www.gnu.org/licenses/gpl-3.0.html
