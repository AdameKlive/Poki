function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local target = Player(param)
    if target == nil then
        player:sendCancelMessage("Gracz nie znaleziony.")
        return false
    end

    if target:getGroup():getAccess() then
        player:sendCancelMessage("Nie możesz wyrzucić tego gracza.")
        return false
    end

    target:remove()
    return false
end