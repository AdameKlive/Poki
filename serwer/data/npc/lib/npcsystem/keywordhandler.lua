-- Zaawansowany System NPC by Jiddo

if KeywordHandler == nil then

    -- Definicja obiektu KeywordNode
    KeywordNode = {
        keywords = nil,    -- Słowa kluczowe (tablica lub obiekt z funkcją zwrotną)
        callback = nil,    -- Funkcja zwrotna do wywołania po dopasowaniu słów kluczowych
        parameters = nil,  -- Parametry przekazywane do funkcji zwrotnej
        children = nil,    -- Tabela węzłów potomnych
        parent = nil,      -- Rodzic tego węzła w hierarchii
        condition = nil,   -- Funkcja warunku, która musi zostać spełniona
        action = nil       -- Funkcja akcji do wykonania po przetworzeniu wiadomości
    }

    -- Tworzy nowy węzeł słowa kluczowego z podanymi słowami kluczowymi, funkcją zwrotną i parametrami, bez węzłów potomnych.
    function KeywordNode:new(keys, func, param, condition, action)
        local obj = {}
        obj.keywords = keys
        obj.callback = func
        obj.parameters = param
        obj.children = {}
        obj.condition = condition
        obj.action = action
        setmetatable(obj, self)
        self.__index = self
        return obj
    end

    -- Wywołuje bazową funkcję zwrotną, jeśli nie jest nil.
    function KeywordNode:processMessage(cid, message)
        return (self.callback == nil or self.callback(cid, message, self.keywords, self.parameters, self))
    end

    -- Wykonuje akcję przypisaną do węzła.
    function KeywordNode:processAction(cid)
        if not self.action then
            return
        end

        local player = Player(cid)
        if not player then
            return
        end

        self.action(player, self.parameters.npcHandler)
    end

    -- Zwraca prawdę, jeśli wiadomość zawiera wszystkie wzorce/ciągi znalezione w słowach kluczowych.
    function KeywordNode:checkMessage(cid, message)
        if self.keywords.callback ~= nil then
            local ret, data = self.keywords.callback(self.keywords, message)
            if not ret then
                return false
            end

            if self.condition and not self.condition(Player(cid), data) then
                return false
            end
            return true
        end

        local data = {}
        local last = 0
        for _, keyword in ipairs(self.keywords) do
            if type(keyword) == 'string' then
                local a, b = string.find(message, keyword)
                if a == nil or b == nil or a < last then
                    return false
                end
                if keyword:sub(1, 1) == '%' then -- Sprawdza, czy słowo kluczowe zaczyna się od '%' (dla parametrów liczbowych)
                    data[#data + 1] = tonumber(message:sub(a, b)) or nil
                end
                last = a
            end
        end

        if self.condition and not self.condition(Player(cid), data) then
            return false
        end
        return true
    end

    -- Zwraca rodzica tego węzła lub nil, jeśli taki węzeł nie istnieje.
    function KeywordNode:getParent()
        return self.parent
    end

    -- Zwraca tablicę parametrów funkcji zwrotnej związanych z tym węzłem.
    function KeywordNode:getParameters()
        return self.parameters
    end

    -- Zwraca tablicę słów kluczowych wyzwalających związanych z tym węzłem.
    function KeywordNode:getKeywords()
        return self.keywords
    end

    -- Dodaje węzeł potomny do tego węzła. Tworzy węzeł potomny na podstawie parametrów.
    function KeywordNode:addChildKeyword(keywords, callback, parameters, condition, action)
        local new = KeywordNode:new(keywords, callback, parameters, condition, action)
        return self:addChildKeywordNode(new)
    end

    -- Dodaje alias słowa kluczowego dla poprzedniego węzła.
    function KeywordNode:addAliasKeyword(keywords)
        if #self.children == 0 then
            print('KeywordNode:addAliasKeyword nie znaleziono poprzedniego węzła')
            return false
        end

        local prevNode = self.children[#self.children]
        local new = KeywordNode:new(keywords, prevNode.callback, prevNode.parameters, prevNode.condition, prevNode.action)
        for i = 1, #prevNode.children do
            new:addChildKeywordNode(prevNode.children[i])
        end
        return self:addChildKeywordNode(new)
    end

    -- Dodaje wcześniej utworzony węzeł potomny do tego węzła. Należy użyć na przykład, gdy kilka węzłów powinno mieć wspólne dziecko.
    function KeywordNode:addChildKeywordNode(childNode)
        self.children[#self.children + 1] = childNode
        childNode.parent = self
        return childNode
    end

    -- Definicja obiektu KeywordHandler
    KeywordHandler = {
        root = nil,        -- Główny węzeł drzewa słów kluczowych
        lastNode = nil     -- Ostatnio przetworzony węzeł dla każdego gracza
    }

    -- Tworzy nowy obiekt KeywordHandler z pustym węzłem głównym.
    function KeywordHandler:new()
        local obj = {}
        obj.root = KeywordNode:new(nil, nil, nil)
        obj.lastNode = {}
        setmetatable(obj, self)
        self.__index = self
        return obj
    end

    -- Resetuje pole lastNode, co resetuje bieżącą pozycję w hierarchii węzłów do głównego.
    function KeywordHandler:reset(cid)
        if self.lastNode[cid] then
            self.lastNode[cid] = nil
        end
    end

    -- Zapewnia, że odpowiedni węzeł potomny lastNode ma szansę przetworzyć wiadomość.
    function KeywordHandler:processMessage(cid, message)
        local node = self:getLastNode(cid)
        if node == nil then
            error('Nie znaleziono węzła głównego.')
            return false
        end

        local ret = self:processNodeMessage(node, cid, message)
        if ret then
            return true
        end

        if node:getParent() then
            node = node:getParent() -- Szukaj poprzez rodzica.
            local ret = self:processNodeMessage(node, cid, message)
            if ret then
                return true
            end
        end

        if node ~= self:getRoot() then
            node = self:getRoot() -- Szukaj poprzez korzeń.
            local ret = self:processNodeMessage(node, cid, message)
            if ret then
                return true
            end
        end
        return false
    end

    -- Próbuje przetworzyć podaną wiadomość za pomocą dzieci parametru węzła i wywołuje funkcję zwrotną węzła, jeśli znaleziono.
    -- Zwraca węzeł potomny, który przetworzył wiadomość, lub nil, jeśli taki węzeł nie został znaleziony.
    function KeywordHandler:processNodeMessage(node, cid, message)
        local messageLower = message:lower()
        for _, childNode in pairs(node.children) do
            if childNode:checkMessage(cid, messageLower) then
                local oldLast = self.lastNode[cid]
                self.lastNode[cid] = childNode
                childNode.parent = node -- Upewnij się, że węzeł jest rodzicem childNode (ponieważ jeden węzeł może być rodzicem dla kilku węzłów).
                if childNode:processMessage(cid, message) then
                    childNode:processAction(cid)
                    return true
                end
                self.lastNode[cid] = oldLast
            end
        end
        return false
    end

    -- Zwraca główny węzeł słowa kluczowego.
    function KeywordHandler:getRoot()
        return self.root
    end

    -- Zwraca ostatnio przetworzony węzeł słowa kluczowego lub węzeł główny, jeśli nie znaleziono ostatniego węzła.
    function KeywordHandler:getLastNode(cid)
        return self.lastNode[cid] or self:getRoot()
    end

    -- Dodaje nowe słowo kluczowe do głównego węzła słowa kluczowego. Zwraca nowy węzeł.
    function KeywordHandler:addKeyword(keys, callback, parameters, condition, action)
        return self:getRoot():addChildKeyword(keys, callback, parameters, condition, action)
    end

    -- Dodaje alias słowa kluczowego dla poprzedniego węzła.
    function KeywordHandler:addAliasKeyword(keys)
        return self:getRoot():addAliasKeyword(keys)
    end

    -- Przesuwa bieżącą pozycję w hierarchii słów kluczowych o count kroków w górę. Wartość domyślna count = 1.
    -- Ta funkcja MOŻE jeszcze nie działać poprawnie. Używaj na własne ryzyko.
    function KeywordHandler:moveUp(cid, steps)
        if steps == nil or type(steps) ~= "number" then
            steps = 1
        end
        for i = 1, steps do
            if self.lastNode[cid] == nil then
                return nil
            end
            self.lastNode[cid] = self.lastNode[cid]:getParent() or self:getRoot()
        end
        return self.lastNode[cid]
    end
end