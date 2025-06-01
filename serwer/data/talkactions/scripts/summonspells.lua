function onSay(player, words, param)
    local summon = player:getSummon()
    if not summon then
        player:sendCancelMessage("Przepraszamy, to niemożliwe. Potrzebujesz Pokemona, aby rzucać zaklęcia.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local tile = Tile(player:getPosition())
    if tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        player:sendCancelMessage("Przepraszamy, to niemożliwe w strefie ochronnej.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local summonName = summon:getName()
    local monsterType = MonsterType(summonName)
    local move = monsterType:getMoveList()
    local target = summon:getTarget()
    
    for i = 1, #moveWords do
        if words == moveWords[i] then            
            if move[i] then
                if move[i].isTarget == 1 and not target then
                    player:sendCancelMessage("Przepraszamy, to niemożliwe. Potrzebujesz celu.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end
                if target and move[i].isTarget == 1 and move[i].range ~= 0 and summon:getPosition():getDistance(target:getPosition()) > move[i].range then
                    player:sendCancelMessage("Przepraszamy, to niemożliwe. Jesteś za daleko.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end
                if getCreatureCondition(summon, CONDITION_SLEEP) then
                    player:sendCancelMessage("Przepraszamy, to niemożliwe. Twój Pokemon śpi.")
                    player:getPosition():sendMagicEffect(CONST_ME_POFF)
                    break
                end
                local exhausted = player:checkMoveExhaustion(i, move[i].speed / 1000)
				print("SummonSpells DEBUG: Dla gracza " .. player:getName() .. ", skill index " .. i .. ", exhausted = " .. tostring(exhausted))
				if not exhausted then
					local moveName = move[i].name
					local castSuccess = doCreatureCastSpell(summon, moveName) -- Wywołuje onCastSpell w thunder.lua
					if castSuccess then -- Tylko jeśli onCastSpell w thunder.lua zwrócił true
						player:say(summonName .. ", use " .. moveName .. "!", TALKTYPE_MONSTER_SAY)
					end
				-- Jeśli jest exhausted, to funkcja player:checkMoveExhaustion prawdopodobnie sama wysyła komunikat o cooldownie
				-- else
				-- player:sendCancelMessage("DEBUG: Ruch jest na cooldownie wg checkMoveExhaustion.") -- Możesz dodać do testów
				end
            else
                player:sendCancelMessage("SUMMONSPELLS DEBUG: Ruch na cooldownie wg checkMoveExhaustion!") -- Testowy komunikat
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
                break
            end
        end
    end
    return false
end