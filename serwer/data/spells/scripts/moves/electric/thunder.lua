local combat = COMBAT_ELECTRICDAMAGE
local time = 400

local area = {}
table.insert(area, createCombatArea(LeafStorm1))
table.insert(area, createCombatArea(LeafStorm2))
table.insert(area, createCombatArea(LeafStorm3))
table.insert(area, createCombatArea(LeafStorm4))

local areaDamage = {}
for i = 1, 4 do
    table.insert(areaDamage, createCombatArea(AREA_CIRCLE5X5))
end

local effect = {772, 772, 772, 772}

local damageMultiplier = damageMultiplierMoves.ultimate / #area

-- Główna funkcja działania skilla
local function spellCallback(uid, position, damage, count)
    local creature = Creature(uid)
    if creature then		
        if count <= #area then
            if not effect[count] or not areaDamage[count] then return true end
            doAreaCombatHealth(uid, combat, position, area[count], 0, 0, effect[count])
            doAreaCombatHealth(uid, combat, position, areaDamage[count], -damage, -damage, 0)
            count = count + 1			
            addEvent(spellCallback, time, uid, position, damage, count)
        end
    end
end

-- Główna funkcja rzucania czaru
function onCastSpell(creature, variant)
    local player = Player(creature:getMaster()) -- pobierz trenera
    local pokeName = creature:getName():lower()
    local spellName = "thunder"

    -- Sprawdź poziom wymagany z pokehabilidades
    local minLevel = SkillLock[pokeName] and SkillLock[pokeName][spellName]
    if not minLevel then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Ten atak nie jest dostępny dla " .. pokeName .. ".")
        return false
    end

    if creature:getLevel() < minLevel then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, pokeName .. " potrzebuje przynajmniej poziomu " .. minLevel .. ", aby użyć " .. spellName .. ".")
        
        -- Wyłącz animację cooldownu tylko dla tego skilla
    end

    -- Oblicz obrażenia i rozpocznij atak
    local damage = damageMultiplier * creature:getTotalMagicAttack()
    local position = creature:getPosition()
    spellCallback(creature.uid, position, damage, 1)

    return true
end
