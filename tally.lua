#!/usr/bin/lua
-- Copyright 2012-2013 Craig Barnes
-- Licensed under the ISC license

local lfs = require "lfs"
local lpeg = require "lpeg"
local P = lpeg.P
local S = lpeg.S
local subtotals, sorted, files = {}, {}, {}

local function countc(filename)
    local file = assert(io.open(filename))
    local text = file:read("*a")
    file:close()
    local count = 0
    local newline = P'\n'^1 / function() count = count + 1 end
    local stringlit = P'L'^-1 * P'"' * (P'\\' * P(1) + (1 - S'\\"'))^0 * P'"'
    local longcomment = P'/*' * (1 - P'*/')^0 * P'*/' * P'\n'^0
    local linecomment = P'//' * (1 - P'\n')^0 * P'\n'
    local comment = (longcomment + linecomment)
    local tokens = (comment + stringlit + newline + 1)^0
    lpeg.match(tokens, text)
    return count
end

local extensions = {
    asm = "Assembly", S = "Assembly",
    awk = "AWK",
    bash = "Shell",
    c = "C",
    cc = "C++", cpp = "C++", cxx = "C++",
    coffee = "CoffeeScript",
    css = "CSS",
    go = "Go",
    h = "C Header",
    hs = "Haskell",
    htm = "HTML", html = "HTML", xhtml = "HTML",
    java = "Java",
    js = "JavaScript",
    json = "JSON",
    l = "Lex",
    lua = "Lua",
    markdown = "Markdown", md = "Markdown", mkd = "Markdown", mkdn = "Markdown",
    mk = "Make", mak = "Make", make = "Make",
    page = "Mallard",
    perl = "Perl", pl = "Perl", pm = "Perl",
    py = "Python",
    rb = "Ruby",
    scss = "SCSS",
    scm = "Scheme",
    sed = "SED",
    sh = "Shell",
    sql = "SQL",
    tcl = "TCL",
    vala = "Vala",
    y = "Yacc",
    yaml = "YAML", yml = "YAML",
    xml = "XML",
}

local hashbangs = {
    awk = "AWK",
    bash = "Shell",
    lua = "Lua",
    make = "Make",
    perl = "Perl",
    python = "Python",
    ruby = "Ruby",
    sed = "SED",
    sh = "Shell",
    tcl = "TCL",
}

local comments = {
    AWK = "#",
    C = countc,
    ["C Header"] = countc,
    CSS = countc,
    ["C++"] = countc,
    CoffeeScript = "#",
    Go = countc,
    Haskell = "%-%-",
    Java = countc,
    JavaScript = countc,
    Lua = "%-%-",
    Make = "#",
    Perl = "#",
    Python = "#",
    Ruby = "#",
    Sass = countc,
    Scheme = ";",
    SED = "#",
    Shell = "#",
    SQL = "%-%-",
    TCL = "#",
    Vala = countc,
    YAML = "#",
}

local function dirtree(dir)
    assert(dir and dir ~= "", "directory parameter is missing or empty")
    if dir:sub(-1) == "/" then dir = dir:sub(1, -2) end
    local function yieldtree(dir)
        for entry in lfs.dir(dir) do
            if entry:sub(1, 1) ~= "." then
                entry = dir .. "/" .. entry
                local attr = lfs.attributes(entry)
                if not attr then
                    break
                elseif attr.mode == "file" then
                    coroutine.yield(entry)
                elseif attr.mode == "directory" then
                    yieldtree(entry)
                end
            end
        end
    end
    return coroutine.wrap(function() yieldtree(dir) end)
end

local function findtype(filename)
    local ext = filename:match "%.(%w*)$"
    if ext then
        return extensions[ext]
    elseif filename:match "[Mm]akefile$" then
        return "Make"
    else
        local file = io.open(filename)
        if file then
            local firstline = file:read()
            file:close()
            if firstline then
                return hashbangs[firstline:match "^#!.*/(.*)"]
            end
        end
    end
end

local function countlines(filename, comment)
    local comment = comment or "#"
    local count = 0
    for line in io.lines(filename) do
        if not line:find("^%s*$") and not line:find("^%s*" .. comment) then
            count = count + 1
        end
    end
    return count
end

local args = select("#", ...) > 0 and {...} or {"."}

for i = 1, #args do
    local path = args[i]
    local attr = lfs.attributes(path)
    if not attr then
        break
    elseif attr.mode == "directory" then
        for file in dirtree(path) do
            table.insert(files, file)
        end
    elseif attr.mode == "file" then
        table.insert(files, path)
    end
end

io.stderr:write(string.format("Scanning %d files...", #files))

for i, filename in ipairs(files) do
    local filetype = findtype(filename)
    if filetype then
        local c = comments[filetype]
        local count
        if type(c) == "function" then
            count = c(filename)
        else
            count = countlines(filename, c)
        end
        subtotals[filetype] = (subtotals[filetype] or 0) + count
    end
end

io.stderr:write "\27[2K\r" -- Erase current line and reset cursor

for lang, lines in pairs(subtotals) do
    sorted[#sorted+1] = {lang=lang, lines=lines}
end

table.sort(sorted, function(a, b)
    return a.lines > b.lines
end)

local format do -- Find shortest format alignment lengths
    local langmax, linemax = 0, 0
    for i = 1, #sorted do
        local langlen, linelen = #sorted[i].lang, #tostring(sorted[i].lines)
        langmax = langlen > langmax and langlen or langmax
        linemax = linelen > linemax and linelen or linemax
    end
    format = "%-" .. langmax .. "s  %" .. linemax .. "d\n"
end

for i = 1, #sorted do
    io.write(string.format(format, sorted[i].lang, sorted[i].lines))
end
