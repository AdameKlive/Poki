local condition = Condition(CONDITION_OUTFIT, CONDITIONID_COMBAT)
condition:setTicks(-1)

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local itemType = ItemType(param)
    if itemType:getId() == 0 then
        itemType = ItemType(tonumber(param))
        if itemType:getId() == 0 then
            player:sendCancelMessage("Nie ma przedmiotu o takim ID lub nazwie.")
            return false
        end
    end

    condition:setOutfit(itemType:getId())
    player:addCondition(condition)
    return false
end