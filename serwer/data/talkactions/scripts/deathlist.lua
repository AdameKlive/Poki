local function getArticle(str)
    -- Ta funkcja określa, czy użyć "an" czy "a" przed angielskim słowem.
    -- W tłumaczeniu na polski nie ma bezpośredniego odpowiednika, więc ta funkcja
    -- zostanie usunięta lub zmieniona, jeśli konieczne będzie użycie rodzajników.
    -- Na potrzeby tego tłumaczenia, zostanie to pominięte w finalnym stringu,
    -- ponieważ język polski nie używa przedimków.
    return "" -- Zwracamy pusty string, ponieważ w języku polskim nie ma przedimków.
end

local function getMonthDayEnding(day)
    -- Ta funkcja dodaje końcówki do daty (np. "st", "nd", "rd", "th").
    -- W języku polskim zazwyczaj używamy po prostu liczby z kropką, np. "1." czerwiec.
    -- Końcówki te nie mają bezpośredniego odpowiednika w polskiej gramatyce dat.
    return "."
end

local function getMonthString(m)
    -- Zwraca nazwę miesiąca na podstawie jego numeru.
    -- W tym przypadku, użyjemy polskich nazw miesięcy.
    local months = {
        "styczeń", "luty", "marzec", "kwiecień", "maj", "czerwiec",
        "lipiec", "sierpień", "wrzesień", "październik", "listopad", "grudzień"
    }
    return months[m] or ""
end

function onSay(player, words, param)
    local resultId = db.storeQuery("SELECT `id`, `name` FROM `players` WHERE `name` = " .. db.escapeString(param))
    if resultId ~= false then
        local targetGUID = result.getDataInt(resultId, "id")
        local targetName = result.getDataString(resultId, "name")
        result.free(resultId)
        local str = ""
        local breakline = ""

        local resultId = db.storeQuery("SELECT `time`, `level`, `killed_by`, `is_player` FROM `player_deaths` WHERE `player_id` = " .. targetGUID .. " ORDER BY `time` DESC")
        if resultId ~= false then
            repeat
                if str ~= "" then
                    breakline = "\n"
                end
                local date = os.date("*t", result.getDataInt(resultId, "time"))

                local killed_by = result.getDataString(resultId, "killed_by")
                if result.getDataInt(resultId, "is_player") == 0 then
                    -- W tym przypadku nie ma potrzeby dodawania 'a'/'an', ponieważ w języku polskim nie ma przedimków.
                    -- Można by tu dodać odpowiednie formy rodzajnika (np. "przez potwora X"), ale
                    -- dla zachowania prostoty i bez tłumaczenia nazw własnych, pozostawiamy "przez [nazwa]".
                    killed_by = string.lower(killed_by) -- Pozostawiamy małe litery dla potworów, jeśli tak było w oryginale
                end

                if date.day < 10 then date.day = "0" .. date.day end
                if date.hour < 10 then date.hour = "0" .. date.hour end
                if date.min < 10 then date.min = "0" .. date.min end
                if date.sec < 10 then date.sec = "0" .. date.sec end

                -- Formatowanie daty i tekstu na polski
                str = str .. breakline .. " " .. date.day .. getMonthDayEnding(date.day) .. " " .. getMonthString(date.month) .. " " .. date.year .. " " .. date.hour .. ":" .. date.min .. ":" .. date.sec .. "  Zginął na Poziomie " .. result.getDataInt(resultId, "level") .. " przez " .. killed_by .. "."
            until not result.next(resultId)
            result.free(resultId)
        end

        if str == "" then
            str = "Brak zgonów."
        end
        player:popupFYI("Lista zgonów dla gracza, " .. targetName .. ".\n\n" .. str)
    else
        player:sendCancelMessage("Gracz o tej nazwie nie istnieje.")
    end
    return false
end