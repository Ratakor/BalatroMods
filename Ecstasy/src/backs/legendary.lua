SMODS.Back {
    key = "legendary",
    atlas = "Backs",
    pos = { x = 0, y = 0 },
    loc_vars = function()
        return {
            vars = {
                colours = { HEX("C75985") }
            },
        }
    end,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
                    card:set_eternal(true)
                    card:add_to_deck()
                    card:start_materialize()
                    G.jokers:emplace(card)
                    return true
                end
            end,
        }))
    end
}
