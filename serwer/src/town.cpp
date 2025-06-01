/*
 * Copyright (c) 2010-2017 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "otpch.h"

#include "town.h"
#include "position.h"
#include <string>
#include <list>
#include <algorithm>
#include <memory>
#include <cstdint>

TownManager g_towns;

// Poprawione konstruktory i dostêp do pól
Town::Town(uint32_t tid, const std::string& name, const Position& pos)
    : id(tid), name(name), templePosition(pos), m_pos(pos)
{
    if (!pos.isValid())
        m_pos = Position();
}

Town::Town()
    : id(0), name(""), templePosition(), m_pos()
{
}

TownManager::TownManager()
{
    m_nullTown = std::make_shared<Town>();
}

void TownManager::addTown(const TownPtr &town)
{
    if(findTown(town->id) == m_towns.end())
        m_towns.push_back(town);
}

void TownManager::removeTown(uint32_t townId)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
        [townId](const TownPtr& town) -> bool {
            return town->id == townId;
        });
    if (it != m_towns.end())
        m_towns.erase(it);
}

const TownPtr& TownManager::getTown(uint32_t townId)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
                           [townId](const TownPtr& town) -> bool { return town->id == townId; });
    if (it != m_towns.end())
        return *it;
    return m_nullTown;
}

const TownPtr& TownManager::getTownByName(const std::string& name)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
                           [&name](const TownPtr& town) -> bool { return town->name == name; });
    if (it != m_towns.end())
        return *it;
    return m_nullTown;
}

std::list<std::shared_ptr<Town>>::iterator TownManager::findTown(uint32_t townId)
{
    return std::find_if(m_towns.begin(), m_towns.end(),
                        [townId](const TownPtr& town) -> bool { return town->id == townId; });
}

void TownManager::sort()
{
    m_towns.sort([](const TownPtr& lhs, const TownPtr& rhs) -> bool { 
        return lhs->name < rhs->name; 
    });
}
// Plan dzia³ania (pseudokod):
// 1. Zamieñ bezpoœredni dostêp do pól id i name klasy Town na wywo³ania metod getID() i getName().
// 2. Popraw konstruktory Town, aby nie inicjalizowaæ nieistniej¹cych pól (id, name) w liœcie inicjalizacyjnej.
// 3. Wszêdzie, gdzie jest town->id lub town->name, zamieñ na town->getID() lub town->getName().
// 4. Popraw sortowanie, aby u¿ywa³o getName().

#include "otpch.h"

#include "town.h"
#include "position.h"
#include <string>
#include <list>
#include <algorithm>
#include <memory>
#include <cstdint>

TownManager g_towns;

// Poprawione konstruktory i dostêp do pól
Town::Town(uint32_t tid, const std::string& name, const Position& pos)
{
    id = tid;
    this->name = name;
    templePosition = pos;
    m_pos = pos;
    if (!pos.isValid())
        m_pos = Position();
}

Town::Town()
{
    id = 0;
    name = "";
    templePosition = Position();
    m_pos = Position();
}

TownManager::TownManager()
{
    m_nullTown = std::make_shared<Town>();
}

void TownManager::addTown(const TownPtr &town)
{
    if(findTown(town->getID()) == m_towns.end())
        m_towns.push_back(town);
}

void TownManager::removeTown(uint32_t townId)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
        [townId](const TownPtr& town) -> bool {
            return town->getID() == townId;
        });
    if (it != m_towns.end())
        m_towns.erase(it);
}

const TownPtr& TownManager::getTown(uint32_t townId)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
                           [townId](const TownPtr& town) -> bool { return town->getID() == townId; });
    if (it != m_towns.end())
        return *it;
    return m_nullTown;
}

const TownPtr& TownManager::getTownByName(const std::string& name)
{
    auto it = std::find_if(m_towns.begin(), m_towns.end(),
                           [&name](const TownPtr& town) -> bool { return town->getName() == name; });
    if (it != m_towns.end())
        return *it;
    return m_nullTown;
}

std::list<std::shared_ptr<Town>>::iterator TownManager::findTown(uint32_t townId)
{
    return std::find_if(m_towns.begin(), m_towns.end(),
                        [townId](const TownPtr& town) -> bool { return town->getID() == townId; });
}

void TownManager::sort()
{
    m_towns.sort([](const TownPtr& lhs, const TownPtr& rhs) -> bool { 
        return lhs->getName() < rhs->getName(); 
    });
}
