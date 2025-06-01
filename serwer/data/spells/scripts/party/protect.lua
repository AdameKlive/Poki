local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_SUBID, 2)
condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000) -- 2 minuty
condition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 3)
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local baseMana = 90

function onCastSpell(creature, variant, isHotkey)
	local position = creature:getPosition()
	local party = creature:getParty()
	if not party then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader() -- Dodaje lidera do listy, aby upewnić się, że jest uwzględniony

	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local affectedList = {}
	for _, targetPlayer in ipairs(membersList) do
		-- Sprawdza, czy członek drużyny jest w zasięgu 36 kratek
		if targetPlayer:getPosition():getDistance(position) <= 36 then
			affectedList[#affectedList + 1] = targetPlayer
		end
	end

	local count = #affectedList
	if count <= 1 then -- Jeśli tylko rzucający zaklęcie jest w zasięgu, lub nikt inny
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Oblicza zużycie many na podstawie liczby dotkniętych członków
	local mana = math.ceil((0.9 ^ (count - 1) * baseMana) * count)
	
	if creature:getMana() < mana then
		creature:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA) -- Za mało many
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	elseif not combat:execute(creature, variant) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE) -- Niemożliwe do wykonania
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Odzyskana mana i zużyta mana są skorygowane na podstawie obliczeń
	creature:addMana(baseMana - mana, false)
	creature:addManaSpent(mana - baseMana)

	-- Dodaje warunek (buff) do wszystkich dotkniętych członków drużyny
	for _, targetPlayer in ipairs(affectedList) do
		targetPlayer:addCondition(condition)
	end
	return true
end