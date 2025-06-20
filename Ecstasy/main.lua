local mod = SMODS.current_mod

local function load_dir(dir)
    dir = "src/" .. dir
    local files = NFS.getDirectoryItems(mod.path .. dir)
    for _, file in ipairs(files) do
        assert(SMODS.load_file(dir .. "/" .. file))()
    end
end

load_dir("backs")
load_dir("misc")

if next(SMODS.find_mod("CardSleeves")) then
  load_dir("sleeves")
end
