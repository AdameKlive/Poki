dofile("data/lib/pokehabilidades.lua")

function onSay(player, words, param)
    local summon = player:getSummon()
    if not summon then
        player:sendCancelMessage("Przykro mi, musisz mieć przywołanego Pokémona, aby używać ataków.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local tile = Tile(player:getPosition())
    if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        player:sendCancelMessage("Nie możesz używać ataków w strefie ochronnej.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local summonName = summon:getName():lower()
    local monsterType = MonsterType(summonName)
    local move = monsterType:getMoveList()
    local target = summon:getTarget()

    for i = 1, #moveWords do
        if words == moveWords[i] then
            if move[i] then
                if move[i].isTarget == 1 and not target then
                    player:sendCancelMessage("Musisz wskazać cel, aby użyć tego ataku.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end
                if target and move[i].isTarget == 1 and move[i].range ~= 0 and summon:getPosition():getDistance(target:getPosition()) > move[i].range then
                    player:sendCancelMessage("Cel jest zbyt daleko.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end
                if getCreatureCondition(summon, CONDITION_SLEEP) then
                    player:sendCancelMessage("Twój Pokémon śpi i nie może używać ataków.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end

                local spellName = move[i].name:lower()
                local requiredLevel = SkillLock[summonName] and SkillLock[summonName][spellName]

                if requiredLevel and summon:getLevel() < requiredLevel then
                    -- ❌ Wyłączenie animacji cooldownu i komunikatu
                    if SkillLock.MoveSettings[spellName] then
                        SkillLock.MoveSettings[spellName].disableCooldownAnimation = true
                        SkillLock.MoveSettings[spellName].disableCooldownMessage = true
                    end

                    player:sendCancelMessage(summonName .. " potrzebuje przynajmniej poziomu " .. requiredLevel .. ", aby użyć " .. spellName .. ".")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                else
                    -- ✅ Przywrócenie domyślnych ustawień — czyli pozwalamy na animację!
                    if SkillLock.MoveSettings[spellName] then
                        SkillLock.MoveSettings[spellName].disableCooldownAnimation = false
                    end
                end

                local exhausted = player:checkMoveExhaustion(i, move[i].speed / 1000)
                if not exhausted then
                    player:say(summon:getName() .. ", użyj " .. move[i].name .. "!", TALKTYPE_MONSTER_SAY)
                    doCreatureCastSpell(summon, move[i].name)
                end
            else
                player:sendCancelMessage("Przykro mi, nie można użyć tej komendy.")
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
                break
            end
        end
    end
    return false
end
