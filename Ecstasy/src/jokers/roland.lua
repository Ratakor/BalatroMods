SMODS.Joker {
    key = "ecstasy_roland",
    atlas = "Jokers",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 1 },
    rarity = 4,
    cost = 20,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {
        extra = {
            bonus = 0.1,
            xmult = 1,
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.bonus,
                card.ability.extra.xmult,
            },
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        if context.using_consumable and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.bonus
            return {
                focus = card,
                message = localize({ type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } }),
                card = card,
            }
        end
    end,
}
