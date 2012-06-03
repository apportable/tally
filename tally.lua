#!/usr/bin/lua

local lfs = require "lfs"

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
    c = "C",
    lua = "Lua",
    rb = "Ruby",
}

local hashbangs = {
    Lua = "^#!.*/bash",
    AWK = "^#!.*/awk",
    SED = "^#!.*/sed",
}

local function findtype(filename)
    local ext = filename:match("^.*%.(.*)$")
    if ext and extensions[ext:lower()] then
        return extensions[ext:lower()]
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

for filename in dirtree(os.getenv("PWD")) do
    local filetype = findtype(filename)
    if filetype then print(filetype, filename) end
end
