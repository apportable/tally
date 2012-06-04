#!/usr/bin/lua

local lfs = require "lfs"
local subtotals = {}
local total = 0

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

local function firstline(filename)
    local file = io.open(filename, "r")
    if file then
        local hashbang = file:read()
        file:close()
        return hashbang
    end
end

local extensions = {
    asm = "Assembly",
    awk = "AWK",
    bash = "Shell",
    c = "C",
    css = "CSS",
    haskell = "Haskell",
    html = "HTML",
    js = "JavaScript",
    l = "Lex",
    lua = "Lua",
    perl = "Perl",
    pl = "Perl",
    pm = "Perl",
    py = "Python",
    rb = "Ruby",
    s = "Assembly",
    sed = "SED",
    sh = "Shell",
    sql = "SQL",
    tcl = "TCL",
    y = "Yacc",
}

local hashbangs = {
    AWK = "^#!.*/awk",
    Lua = "^#!.*/lua",
    Perl = "^#!.*/perl",
    Python = "^#!.*/python",
    Ruby = "^#!.*/ruby",
    SED = "^#!.*/sed",
    Shell = "^#!.*/b?[ackz]?sh",
    TCL = "^#!.*/tcl",
}

local comments = {
    AWK = "#",
    JavaScript = "//",
    Lua = "%-%-",
    Make = "#",
    Perl = "#",
    Python = "#",
    Ruby = "#",
    SED = "#",
    Shell = "#",
    SQL = "%-%-",
}

local function findtype(filename)
    local ext = filename:match("^.*%.(.*)$")
    if ext and extensions[ext:lower()] then
        return extensions[ext:lower()]
    elseif filename:match("^.*[Mm]akefile$") then
        return "Make"
    else
        local hashbang = firstline(filename)
        if hashbang and hashbang:sub(1, 2) == "#!" then
            for k, v in pairs(hashbangs) do
                if hashbang:find(v) then
                    return k
                end
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

for filename in dirtree(os.getenv("PWD")) do
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

local function print(left, right)
    io.write(string.format("%-8s  %d\n", left, right))
end

for language, subtotal in pairs(subtotals) do
    total = total + subtotal
    print(language, subtotal)
end

print("Total", total)
