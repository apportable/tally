#!/usr/bin/lua
-- Copyright 2012, Craig Barnes
-- Licensed under the ISC license

local lfs = require "lfs"
local subtotals, sorted = {}, {}

local extensions = {
    asm = "Assembly",
    awk = "AWK",
    bash = "Shell",
    c = "C",
    cc = "C++",
    coffee = "CoffeeScript",
    cpp = "C++",
    css = "CSS",
    cxx = "C++",
    hs = "Haskell",
    htm = "HTML",
    html = "HTML",
    js = "JavaScript",
    json = "JSON",
    l = "Lex",
    lua = "Lua",
    markdown = "Markdown",
    md = "Markdown",
    mk = "Make",
    mkd = "Markdown",
    mkdn = "Markdown",
    page = "Mallard",
    perl = "Perl",
    pl = "Perl",
    pm = "Perl",
    py = "Python",
    rb = "Ruby",
    S = "Assembly",
    scm = "Scheme",
    sed = "SED",
    sh = "Shell",
    sql = "SQL",
    tcl = "TCL",
    vala = "Vala",
    y = "Yacc",
    yaml = "YAML",
    yml = "YAML",
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
    ["C++"] = "//",
    CoffeeScript = "#",
    JavaScript = "//",
    Haskell = "%-%-",
    Lua = "%-%-",
    Make = "#",
    Perl = "#",
    Python = "#",
    Ruby = "#",
    Scheme = ";",
    SED = "#",
    Shell = "#",
    SQL = "%-%-",
    TCL = "#",
    Vala = "//",
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
        if subtotals[filetype] then
            subtotals[filetype] = subtotals[filetype] + countlines(filename, c)
        else
            subtotals[filetype] = countlines(filename, c)
        end
    end
end

for language, subtotal in pairs(subtotals) do
    table.insert(sorted, {language=language, subtotal=subtotal})
end

table.sort(sorted, function(a, b) return a.subtotal > b.subtotal end)

for i, v in ipairs(sorted) do
    io.write(string.format("%-10s %4d\n", v.language, v.subtotal))
end
