local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'książę'}, StdModule.say, {npcHandler = npcHandler, text = "Jeśli kolejny książę spróbuje mnie pocałować, tak mu skopię tyłek, że będzie potrzebował lektyki, żeby się stąd zabrać."})
keywordHandler:addKeyword({'księżniczka'}, StdModule.say, {npcHandler = npcHandler, text = "Jeśli kolejny książę spróbuje mnie pocałować, tak mu skopię tyłek, że będzie potrzebował lektyki, żeby się stąd zabrać."})
keywordHandler:addKeyword({'pocałuj'}, StdModule.say, {npcHandler = npcHandler, text = "Nawet nie próbuj mnie całować, bo dostaniesz z kopniaka z półobrotu!"})
keywordHandler:addKeyword({'rozmawiać'}, StdModule.say, {npcHandler = npcHandler, text = "Gadające żaby nie istnieją, idioto. To twoja pieprzona wyobraźnia cię oszukuje. A teraz twoja wyobraźnia każe ci odejść."})
keywordHandler:addKeyword({'żaba'}, StdModule.say, {npcHandler = npcHandler, text = "W końcu ktoś zauważył, że jestem ŻABĄ. Gratulacje, jesteś BARDZO spostrzegawczy... *wzdycha*"})
keywordHandler:addKeyword({'zadanie'}, StdModule.say, {npcHandler = npcHandler, text = "Zadanie? Tak, mam zadanie! Idź i powiedz Królowi Tibianusowi, że jego syn znowu próbował mnie pocałować!"})
keywordHandler:addKeyword({'pyrale'}, StdModule.say, {npcHandler = npcHandler, text = "Pyrale? Ten idiota raz zamienił mnie w człowieka. Ale moja żona przyszła i pocałowała mnie, więc znowu jestem żabą."})
keywordHandler:addKeyword({'kumkum'}, StdModule.say, {npcHandler = npcHandler, text = "Pyrale? Ten idiota raz zamienił mnie w człowieka. Ale moja żona przyszła i pocałowała mnie, więc znowu jestem żabą."})

npcHandler:setMessage(MESSAGE_GREET, "*wzdycha* Kolejny tępy poszukiwacz przygód.")
npcHandler:setMessage(MESSAGE_FAREWELL, "No to cześć i nie wracaj!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Ha! Ten idiota w końcu odszedł.")
npcHandler:addModule(FocusModule:new())