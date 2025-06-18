--- STEAMODDED HEADER
--- MOD_NAME: Keyboard
--- MOD_ID: keyboard
--- MOD_AUTHOR: [Ratakor]
--- MOD_DESCRIPTION: Add keyboard shortcuts to the game
----------------------------------------------
------------MOD CODE -------------------------

local sorted_by_rank = true
local selected_card_i = 0

G.ORPHANED_UIBOXES = {}
local uibox_init_impl = UIBox.init
function UIBox.init(self, args)
    if not args.config.parent then G.ORPHANED_UIBOXES[self] = true end
    return uibox_init_impl(self, args)
end

local uibox_remove_impl = UIBox.remove
function UIBox.remove(self)
    G.ORPHANED_UIBOXES[self] = nil
    return uibox_remove_impl(self)
end

local keyupdate_ref = Controller.key_press_update
function Controller.key_press_update(self, key, dt)
    keyupdate_ref(self, key, dt)
    local keys_to_nums = {
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["0"] = 10,
        ["j"] = 11,
        ["q"] = 12,
        ["k"] = 13,
        ["1"] = 14,
    }

    if G.STAGE == G.STAGES.RUN then
        if G.STATE == G.STATES.ROUND_EVAL then
            if key == "space" or key == "return" then -- cash out
                local cash_out_button
                for e, _ in pairs(G.ORPHANED_UIBOXES) do
                    cash_out_button = e:get_UIE_by_ID("cash_out_button")
                    if cash_out_button and cash_out_button.config.button then
                        G.FUNCS.cash_out(cash_out_button)
                        return
                    end
                end
            end
        elseif G.STATE == G.STATES.BLIND_SELECT then
            if key == "space" or key == "return" then -- select blind
                G.FUNCS.select_blind(G.blind_select_opts[string.lower(G.GAME.blind_on_deck)]:get_UIE_by_ID(
                    "select_blind_button"))
            elseif key == "s" then -- skip blind
                G.FUNCS.skip_blind(G.blind_select_opts[string.lower(G.GAME.blind_on_deck)]:get_UIE_by_ID("blind_extras"))
            end
        elseif G.STATE == G.STATES.SHOP then
            if key == "r" then -- reroll shop
                if not ((G.GAME.dollars - G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
                    G.FUNCS.reroll_shop(1)
                end
            elseif key == "space" or key == "return" then -- next hand
                G.FUNCS.toggle_shop(1)
            end
        elseif G.STATE == G.STATES.SELECTING_HAND then
            if table.contains(keys_to_nums, key) then -- toggle a hand by rank
                toggle_by_rank(keys_to_nums[key])
            elseif key == "space" or key == "return" then -- play the highlighted cards
                if #G.hand.highlighted > 0 then
                    local play_button = G.buttons:get_UIE_by_ID('play_button')
                    if play_button.config.button == 'play_cards_from_highlighted' then
                        G.FUNCS.play_cards_from_highlighted()
                    end
                else
                    play_sound("cancel")
                end
            elseif key == "backspace" then -- discard the highlighted cards
                if #G.hand.highlighted > 0 and G.GAME.current_round.discards_left > 0 then
                    local discard_button = G.buttons:get_UIE_by_ID('discard_button')
                    if discard_button.config.button == 'discard_cards_from_highlighted' then
                        G.FUNCS.discard_cards_from_highlighted()
                    end
                else
                    play_sound("cancel")
                end
            elseif key == "tab" then -- toggle sort
                if sorted_by_rank then
                    G.FUNCS.sort_hand_suit()
                    sorted_by_rank = false
                else
                    G.FUNCS.sort_hand_value()
                    sorted_by_rank = true
                end
            elseif key == "z" then -- sort by rank
                G.FUNCS.sort_hand_value()
                sorted_by_rank = true
            elseif key == "x" then -- sort by suit
                G.FUNCS.sort_hand_suit()
                sorted_by_rank = false
            elseif key == "lshift" then -- peek deck
                G.buttons.states.visible = false
                G.deck_preview = UIBox {
                    definition = G.UIDEF.deck_preview(),
                    config = { align = 'tm', offset = { x = 0, y = -0.8 }, major = G.hand, bond = 'Weak' }
                }
            elseif key == "i" then -- invert highlighted cards
                invert_highlighted()
            elseif key == "u" then -- unhighlight all cards
                if #G.hand.highlighted > 0 then
                    G.hand:unhighlight_all()
                    play_sound("cardSlide2", nil, 0.3)
                else
                    play_sound("cancel")
                end
            elseif key == "o" then -- toggle highlight the first 5 cards
                toggle_highlight(table.slice(G.hand.cards, 1, 5))
            elseif key == "p" then -- toggle highlight the last 5 cards
                toggle_highlight(table.slice(G.hand.cards, #G.hand.cards - 4, #G.hand.cards))
            elseif key == "left" then
                if selected_card_i > 1 then
                    selected_card_i = selected_card_i - 1
                else
                    selected_card_i = #G.hand.cards
                end
                G.hand.cards[selected_card_i]:juice_up(0.05, 0.03)
            elseif key == "right" then
                if selected_card_i < #G.hand.cards then
                    selected_card_i = selected_card_i + 1
                else
                    selected_card_i = 1
                end
                G.hand.cards[selected_card_i]:juice_up(0.05, 0.03)
            elseif key == "up" then
                local card = G.hand.cards[selected_card_i]
                if card then
                    if is_highlighted(card) then
                        play_sound("cancel")
                    else
                        G.hand:add_to_highlighted(card, true)
                        play_sound("cardSlide1")
                    end
                else
                    selected_card_i = 1
                end
            elseif key == "down" then
                local card = G.hand.cards[selected_card_i]
                if card then
                    if is_highlighted(card) then
                        G.hand:remove_from_highlighted(card)
                        play_sound("cardSlide2", nil, 0.3)
                    else
                        play_sound("cancel")
                    end
                else
                    selected_card_i = 1
                end
            end
        end

        if key == "a" then -- show run info
            local run_info_button = G.HUD:get_UIE_by_ID('run_info_button')
            if run_info_button.config.button == 'run_info' then
                G.FUNCS.run_info()
            end
        elseif key == "d" then -- show deck info
            G.FUNCS.deck_info()
        end
    end
end

local keyrelease_ref = Controller.key_release_update
function Controller.key_release_update(self, key, dt)
    keyrelease_ref(self, key, dt)
    if G.STATE == G.STATES.SELECTING_HAND then
        if key == "lshift" then -- stop peeking deck
            if G.deck_preview then
                G.buttons.states.visible = true
                G.deck_preview:remove()
                G.deck_preview = nil
            end
        end
    end
end

function is_highlighted(card)
    for _, v in pairs(G.hand.highlighted) do
        if v == card then
            return true
        end
    end
    return false
end

-- given a hand rank (jack=11, queen=12, king=13, ace=14)
-- toggle all cards in your hand with that rank
function toggle_by_rank(rank)
    local cards = {}
    for _, card in pairs(G.hand.cards) do
        if card.facing == "front" and card.base.id == rank then
            table.insert(cards, card)
        end
    end
    toggle_highlight(cards)
end

function invert_highlighted()
    local unhighlighted = table.filter(G.hand.cards, function(x)
        return not is_highlighted(x)
    end)
    G.hand:unhighlight_all()
    toggle_highlight(table.slice(unhighlighted, 1, 5))
end

function toggle_highlight(cards)
    if #cards == 0 then
        play_sound("cancel")
        return
    end

    local has_highlighted = false
    for _, v in pairs(cards) do
        if is_highlighted(v) then
            G.hand:remove_from_highlighted(v)
        else
            G.hand:add_to_highlighted(v, true)
            has_highlighted = true
        end
    end

    if has_highlighted then
        play_sound("cardSlide1")
    else
        play_sound("cardSlide2", nil, 0.3)
    end
end

function table.filter(tbl, f)
    local res = {}
    for _, v in pairs(tbl) do
        if (f(v)) then
            table.insert(res, v)
        end
    end
    return res
end

function table.slice(tbl, first, last, step)
    local res = {}
    for i = first or 1, last or #tbl, step or 1 do
        table.insert(res, tbl[i])
    end
    return res
end

function table.contains(tbl, key)
    for k in pairs(tbl) do
        if k == key then
            return true
        end
    end
    return false
end

----------------------------------------------
------------MOD CODE END----------------------
