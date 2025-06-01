local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local condition = Condition(CONDITION_REGENERATION)
condition:setParameter(CONDITION_PARAM_SUBID, 4)
condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000) -- Czas trwania (2 minuty)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 20) -- Ile punktów zdrowia odzyskuje
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 2000) -- Co ile milisekund odzyskuje zdrowie
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true) -- Czy jest to czar typu "buff"

local baseMana = 120 -- Bazowa ilość many

function onCastSpell(creature, variant, isHotkey)
	local position = creature:getPosition()
	local party = creature:getParty()
    -- Jeśli nie ma drużyny, wyświetla komunikat o błędzie.
	if not party then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader() -- Dodaje lidera drużyny do listy członków

    -- Ponowne sprawdzenie, czy lista członków jest prawidłowa i zawiera więcej niż jednego gracza.
	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local affectedList = {}
    -- Filtruje członków drużyny, którzy są w zasięgu 36 kratek.
	for _, targetPlayer in ipairs(membersList) do
		if targetPlayer:getPosition():getDistance(position) <= 36 then
			affectedList[#affectedList + 1] = targetPlayer
		end
	end

	local count = #affectedList
    -- Jeśli tylko jedna osoba (lub mniej) jest w zasięgu (czyli sam rzucający), anuluje czar.
	if count <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

    -- Oblicza koszt many w zależności od liczby dotkniętych graczy.
	local mana = math.ceil((0.9 ^ (count - 1) * baseMana) * count)
    -- Sprawdza, czy rzucający ma wystarczającą ilość many.
	if creature:getMana() < mana then
		creature:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
    -- Wykonuje działanie bojowe (efekt wizualny).
	elseif not combat:execute(creature, variant) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end
    -- Odzyskuje bazową manę (lub odejmuje jej nadmiar) i dodaje do wydanej many.
	creature:addMana(baseMana - mana, false)
	creature:addManaSpent(mana - baseMana)

    -- Stosuje warunek regeneracji do wszystkich dotkniętych graczy.
	for _, targetPlayer in ipairs(affectedList) do
		targetPlayer:addCondition(condition)
	end
	return true
end