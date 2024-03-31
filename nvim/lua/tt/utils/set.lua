--- An unordered-set like data structure.
---@class Set
---@field public new fun(tbl?): Set
---@field public contains fun(self: Set, value: string|number): boolean
---@field public insert fun(self: Set, value: string|number): nil
---@field public remove fun(self: Set, value: string|number): nil
---@field public insert_or_remove fun(self: Set, value: string|number): nil
---@field public size fun(self: Set): integer
---@field private num_items integer
---@field private items table<string|integer, boolean>
---@overload fun(tbl?: table): Set
local Set = setmetatable({}, {
    __call = function(self, ...)
        return self.new(...)
    end,
})

--- Creates a new instance of a Set.
---@param tbl? table<string|integer>
---@return Set
function Set.new(tbl)
    local self = setmetatable({}, { __index = Set })
    self:init(tbl)
    return self
end

--- Inserts the list items into the set.
---@param tbl? table<string|integer>
function Set:init(tbl)
    self.items = {}
    self.num_items = 0

    if not tbl then
        return
    end

    for _, value in ipairs(tbl) do
        self:insert(value)
    end
end

--- Checks whether the value is contained in the Set.
---@param value string|number
---@return boolean
function Set:contains(value)
    return self.items[value] ~= nil
end

--- Inserts a new element into the set.
---@param value string|number
function Set:insert(value)
    if not self:contains(value) then
        self.items[value] = true
        self.num_items = self.num_items + 1
    end
end

--- Removes an element from the Set.
---@param value string|number
function Set:remove(value)
    if self:contains(value) then
        self.items[value] = nil
        self.num_items = self.num_items - 1
    end
end

--- Adds the value if not present, otherwise removes it.
--- @param value string|integer
function Set:insert_or_remove(value)
    if self:contains(value) then
        self:remove(value)
    else
        self:insert(value)
    end
end

--- Returns the number of elements in the Set.
---@return number
---@nodiscard
function Set:size()
    return self.num_items
end

--- Returns an iterator to the internal items.
function Set:iterator()
    return pairs(self.items)
end

return Set
