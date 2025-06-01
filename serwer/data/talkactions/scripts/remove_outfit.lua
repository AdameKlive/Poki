function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local split = param:split(",")
    if split[2] == nil then
        player:sendCancelMessage("Niewystarczające parametry.")
        return false
    end

    local target = Player(split[1])
    if target == nil then
        player:sendCancelMessage("Gracz o tej nazwie nie jest online.")
        return false
    end

    split[2] = tonumber(split[2])
    if split[2] then
        target:removeOutfit(split[2])
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        return true
    end
    return false
end