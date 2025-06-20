CardSleeves.Sleeve {
    key = "ecstasy_legendary",
    atlas = "Sleeves",
    pos = { x = 0, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_ecstasy_legendary", stake = "stake_black" },
    config = { legendary_odds = 10 },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() == "b_ecstasy_legendary" then
            key = key .. "_alt"
            self.config.joker_boss_blind = true
        else
            self.config.init_joker = true
        end
        return {
            key = key,
            vars = {
                G.GAME and G.GAME.probabilities.normal or 1,
                self.config.legendary_odds,
            },
        }
    end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if not self.config.init_joker then
                    return true
                end
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
    end,
    calculate = function(self, sleeve, context)
        if self.config.joker_boss_blind and context.context == "eval" and (G.GAME.last_blind and G.GAME.last_blind.boss) and G.jokers then
            if pseudorandom("ecstasy_legendary") < G.GAME.probabilities.normal / self.config.legendary_odds then
                local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
                card:set_eternal(true)
                card:set_edition({ negative = true }, true, false)
                card:add_to_deck()
                card:start_materialize()
                G.jokers:emplace(card)
            else
                card_eval_status_text(
                    G.deck,
                    "jokers",
                    nil,
                    nil,
                    nil,
                    { message = localize("k_nope_ex"), colour = G.C.RARITY[4] }
                )
            end
        end
    end,
}
