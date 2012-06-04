Tally
=====

Simple SLOC counter written in Lua.


Status
------

Under development. Currently only semi-accurate.


Installation
------------

    make install PREFIX=/usr/local

Usage
-----

Just `cd` to the directory you want to count and use the `tally` command.
It will recurse into all sub-directories and print a subtotal for each
recognised language and an overall total.

All totals are counted based on source lines only. Blank lines and comment
lines are excluded. File names starting with a dot character are ignored --
including `.`, `..`, `.git` etc.


[License](http://en.wikipedia.org/wiki/ISC_license "ISC license")
---------

Copyright (c) 2012, Craig Barnes

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
