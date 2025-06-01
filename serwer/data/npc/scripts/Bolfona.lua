local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)

    if msgcontains(msg, "chocolate cake") then
        if player:getStorageValue(Storage.hiddenCityOfBeregar.SweetAsChocolateCake) == 1 and player:getItemCount(8847) >= 1 then
            npcHandler:say("Czy to dla mnie?", cid)
            npcHandler.topic[cid] = 1
        elseif player:getStorageValue(Storage.hiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
            npcHandler:say("Powiedziałeś jej, że ciasto było ode mnie?", cid)
            npcHandler.topic[cid] = 2
        end
    elseif msgcontains(msg, "yes") then
        if npcHandler.topic[cid] == 1 then
            if player:removeItem(8847, 1) then
                npcHandler:say("Eee, dzięki. Wątpię, żeby to było od ciebie. Kto to przysłał?", cid)
                npcHandler.topic[cid] = 2
                player:setStorageValue(Storage.hiddenCityOfBeregar.SweetAsChocolateCake, 2)
            else
                npcHandler:say("Och, myślałem, że masz jedno.", cid)
                npcHandler.topic[cid] = 0
            end
        end
    elseif npcHandler.topic[cid] == 2 then
        if msgcontains(msg, "Frafnar") then
            npcHandler:say("Och, Frafnar. To bardzo miło z jego strony. Muszę go zaprosić na piwo.", cid)
            npcHandler.topic[cid] = 0
        else
            npcHandler:say("Nigdy nie słyszałem tego imienia. Cóż, nie mam nic przeciwko, dzięki za ciasto.", cid)
            npcHandler.topic[cid] = 0
        end
    end
    return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do zobaczenia, przyjacielu.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do zobaczenia, przyjacielu.")
npcHandler:setMessage(MESSAGE_GREET, "Mówisz do mnie? No cóż, gadaj dalej, ale nie spodziewaj się odpowiedzi.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())