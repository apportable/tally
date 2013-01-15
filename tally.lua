#!/usr/bin/lua
-- Copyright 2012, Craig Barnes
-- Licensed under the ISC license

local lfs = require "lfs"
local lpeg = require "lpeg"
local subtotals = setmetatable({}, {__index = function() return 0 end})
local sorted = {}

-- Discard C comments and count lines
local function countc(filename)

    -- TODO: doesn't yet discard single line ("//") comments, which should
    -- be optional, e.g. for CSS

    -- TODO: isn't context aware -- strings containing comment delimeters
    -- may result in incorrect count

    local file = assert(io.open(filename, "r"))
    local text = file:read("*a")
    file:close()

    local open = lpeg.P "/*"
    local close = lpeg.P "*/"
    local notopen = (1 - open)^0
    local notclose = (1 - close)^0
    local comment = open * notclose * close
    local notcomment = (lpeg.C(notopen) * comment)^0 * lpeg.C(notclose)

    local accum = {}

    lpeg.Cf(notcomment, function(a, b)
        if a then table.insert(accum, a) end
        if b then table.insert(accum, b) end
    end):match(text)

    local stripped = table.concat(accum)
    if stripped == "" then stripped = text end

    local count = 0
    for line in stripped:gmatch("[^\r\n]+") do
        if not line:find("^%s*$") and not line:find("^%s*//") then
            count = count + 1
        end
    end

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
    hs = "Haskell",
    htm = "HTML", html = "HTML", xhtml = "HTML",
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
    sass = "Sass", scss = "Sass",
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
    CSS = countc,
    ["C++"] = countc,
    CoffeeScript = "#",
    Go = countc,
    Haskell = "%-%-",
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
                if attr.mode == "file" then
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
        local file = io.open(filename, "r")
        if file then
            local firstline = file:read()
            file:close()
            if type(firstline) == "string" then
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

for filename in dirtree(... or ".") do
    local filetype = findtype(filename)
    if filetype then
        local c = comments[filetype]
        local count
        if type(c) == "function" then
            count = c(filename)
        else
            count = countlines(filename, c)
        end
        -- subtotals has __index metamethod that returns 0 (not nil) if empty
        subtotals[filetype] = subtotals[filetype] + count
    end
end

for lang, lines in pairs(subtotals) do
    sorted[#sorted+1] = {lang=lang, lines=lines}
end

table.sort(sorted, function(a, b)
    return a.lines > b.lines
end)

for i = 1, #sorted do
    io.write(string.format("%-10s %4d\n", sorted[i].lang, sorted[i].lines))
end
