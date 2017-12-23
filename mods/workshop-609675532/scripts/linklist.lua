function clazz(_ctor)
	local c = {}    -- a new class instance

	c.__index = c

	-- expose a constructor which can be called by <classname>(<args>)
	local mt = {}
	mt.__call = function(class_tbl, ...)
		local obj = {}
		setmetatable(obj, c)
		if c._ctor then
			c._ctor(obj, ...)
		end
		return obj
	end    

	c._ctor = _ctor
	setmetatable(c, mt)

	return c
end

LinkedList2 = clazz(function(self)
    self._head = nil
    self._tail = nil
    self._count = 0
end)

function LinkedList2:Append(v)
	local elem = {data=v}
	if self._head == nil and self._tail == nil then
		self._head = elem
		self._tail = elem
	else
		elem._prev = self._tail
		self._tail._next = elem
		self._tail = elem
	end
	self._count = self._count + 1
	return v
end

function LinkedList2:Remove(v)
	local current = self._head
	while current ~= nil do
		if current.data == v then
			if current._prev ~= nil then
				current._prev._next = current._next
			else
				self._head = current._next
			end

			if current._next ~= nil then
				current._next._prev = current._prev
			else
				self._tail = current._prev
			end
			self._count = self._count - 1
			return true
		end

		current = current._next
	end

	return false
end

function LinkedList2:Head()
    return self._head and self._head.data or nil
end

function LinkedList2:Tail()
    return self._tail and self._tail.data or nil
end

function LinkedList2:Clear()
	self._head = nil
	self._tail = nil
	self._count = 0
end

function LinkedList2:Count()
	return self._count
end

function LinkedList2:Iterator()
    return {
        _list = self,
        _current = nil,
        Current = function(it)
            return it._current and it._current.data or nil
        end,
        RemoveCurrent = function(it)
            -- use to snip out the current element during iteration

            if it._current._prev == nil and it._current._next == nil then
                -- empty the list!
                it._list:Clear()
                return
            end

            local count = it._list:Count()

            if it._current._prev ~= nil then
                it._current._prev._next = it._current._next
            else
                --assert(it._list._head == it._current)
                it._list._head = it._current._next
            end

            if it._current._next ~= nil then
                it._current._next._prev = it._current._prev
            else
                --assert(it._list._tail == it._current)
                it._list._tail = it._current._prev
            end

			it._list._count = count - 1
            --assert(count-1 == it._list:Count())

            -- NOTE! "current" is now not part of the list, but its _next and _prev still work for iterating off of it.
        end,
        Next = function(it)
            if it._current == nil then
                it._current = it._list._head
            else
                it._current = it._current._next
            end
            return it:Current()
        end,
    }
end



