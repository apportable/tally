Tally
=====
Simple SLOC counter

Description
-----------

Tally is a utility for counting the total lines of source code in a project.
It supports most popular languages and will correctly exclude comments and
display a subtotal for each language.

Tally is implemented as a single, ~60 line shell script.

Installation
------------

    wget https://raw.github.com/craigbarnes/tally/master/tally
    sudo install -Dpm0755 tally /usr/local/bin/tally

Usage
-----

Either `cd` to the directory you want to count and use the `tally` command
or specify the files and directories to count using `tally [PATH]...`.

Tally will count files inside sub-directories but will ignore any path
starting with a dot character (e.g. `.git`).

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
