
local function clone(obj)
    local function _copy(obj)
        if type(obj) ~= 'table' then
            return obj
        else
            local tmp = {}
            for k,v in pairs(obj) do
                tmp[k] = _copy(v)
            end
            return tmp
        end
    end
    return _copy(obj)
end


local function eq(t1, t2)
    local function _eq(a, b)
        local type1 = type(a)
        local type2 = type(b)

        if type1 ~= type2 then
            return false
        end

        if type1 ~= "table" then
            return a == b
        else
            for k,v in pairs(a) do
                if not _eq(v, b[k]) then
                    return false
                end
            end
            for k,v in pairs(b) do
                if not a[k] then
                    return false
                end
            end
            return true
        end
    end

    return _eq(t1, t2)
end


local function differ(t)
	local source = clone(t)


	return function ()
		local diff
		local count = 0

		local function append(k, v)
			diff = diff or {}
			count = count + 1

			table.insert(diff, k)
			table.insert(diff, source[k])
		end

		for k,v in pairs(t) do
			if not eq(source[k], v) then
				source[k] = clone(v)
				append(k, source[k])
			end
		end

		for k,v in pairs(source) do
			if not t[k] then
				source[k] = nil
				append(k)
			end
		end


		local index = 0

		return function ()
			index = index + 1
			if index <= count then
				return diff[index*2-1], diff[index*2]
			end
		end
	end, t
end


return differ