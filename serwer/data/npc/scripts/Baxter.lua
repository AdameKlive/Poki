local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Mieszkańcy Thais, przynieście honor swemu królowi, walcząc w wojnie z orkami!' },
	{ text = 'Orkowie przygotowują się do wojny!!!' }
}

npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "NIECH ŻYJE KRÓL TIBIANUS!")
npcHandler:setMessage(MESSAGE_FAREWELL, "NIECH ŻYJE KRÓL!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "NIECH ŻYJE KRÓL!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Czy przynosisz świeżo zabite szczury za nagrodę 1 złota za sztukę? Przy okazji, kupuję też orkowe zęby i inne rzeczy, które wyrwałeś z ich krwawych zwł... to znaczy... cóż, wiesz, co mam na myśli.")

npcHandler:addModule(FocusModule:new())