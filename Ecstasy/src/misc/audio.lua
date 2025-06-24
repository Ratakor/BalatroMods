local music_nums = { balatro = 1, soiree = 2, business = 3, bside = 4 }
local music_names = { "balatro", "soiree", "business", "bside" }

if not G.SETTINGS.music_selection then
    G.SETTINGS.music_selection = "balatro"
end

settings_tab_ref = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
    local settings_tab = settings_tab_ref(tab)
    if tab == "Audio" then
        local music_selector = {
            n = G.UIT.R,
            config = { align = "cm", r = 0 },
            nodes = {
                create_option_cycle({
                    w = 6,
                    scale = 0.8,
                    label = localize("b_music_selector"),
                    options = localize("ml_music_selector_opt"),
                    opt_callback = "change_music",
                    current_option = music_nums[G.SETTINGS.music_selection]
                }),
            },
        }
        settings_tab.nodes[#settings_tab.nodes + 1] = music_selector
    end
    return settings_tab
end

-- Bonne Soirée https://www.youtube.com/watch?v=KiIXRr_GGCw

SMODS.Sound({
    key = "soiree_music1",
    path = "soiree_music1.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "soiree") and 4 or false
    end,
})

SMODS.Sound({
    key = "soiree_music2",
    path = "soiree_music2.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "soiree" and G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and
        5 or false
    end,
})

SMODS.Sound({
    key = "soiree_music3",
    path = "soiree_music3.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "soiree" and G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and
            5 or false
    end,
})

SMODS.Sound({
    key = "soiree_music4",
    path = "soiree_music4.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "soiree" and G.shop and not G.shop.REMOVED) and 5 or false
    end,
})

SMODS.Sound({
    key = "soiree_music5",
    path = "soiree_music5.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "soiree" and G.GAME.blind and G.GAME.blind.boss) and 5 or false
    end,
})

-- Monkey Business https://www.youtube.com/watch?v=V3ps8wvrmxw

SMODS.Sound({
    key = "business_music1",
    path = "business_music1.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "business") and 4 or false
    end,
})

SMODS.Sound({
    key = "business_music2",
    path = "business_music2.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "business" and G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and
            5 or false
    end,
})

SMODS.Sound({
    key = "business_music3",
    path = "business_music3.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "business" and G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and
            5 or false
    end,
})

SMODS.Sound({
    key = "business_music4",
    path = "business_music4.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "business" and G.shop and not G.shop.REMOVED) and 5 or false
    end,
})

SMODS.Sound({
    key = "business_music5",
    path = "business_music5.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "business" and G.GAME.blind and G.GAME.blind.boss) and 5 or false
    end,
})

-- B-Side https://www.youtube.com/watch?v=_u8tHrRMNG8

SMODS.Sound({
    pitch = 1,
    volume = 1,
    key = "bside_music1",
    path = "bside_music1.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "bside") and 4 or false
    end,
})

SMODS.Sound({
    pitch = 1,
    volume = 1,
    key = "bside_music2",
    path = "bside_music2.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "bside" and G.booster_pack_sparkles and not G.booster_pack_sparkles.REMOVED) and
            5 or false
    end,
})

SMODS.Sound({
    pitch = 1,
    volume = 1,
    key = "bside_music3",
    path = "bside_music3.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "bside" and G.booster_pack_meteors and not G.booster_pack_meteors.REMOVED) and
            5 or false
    end,
})

SMODS.Sound({
    pitch = 1,
    volume = 1,
    key = "bside_music4",
    path = "bside_music4.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "bside" and G.shop and not G.shop.REMOVED) and 5 or false
    end,
})

SMODS.Sound({
    pitch = 1,
    volume = 1,
    key = "bside_music5",
    path = "bside_music5.ogg",
    select_music_track = function()
        return (G.SETTINGS.music_selection == "bside" and G.GAME.blind and G.GAME.blind.boss) and 5 or false
    end,
})

G.FUNCS.change_music = function(args)
    G.SETTINGS.QUEUED_CHANGE.music_change = music_names[args.to_key]
    G.SETTINGS.music_selection = music_names[args.to_key]
end
