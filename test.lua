local differ = require "differ"



local diff, t = differ{a = 1, b = 2}


t.a = nil
t.b = 3

for k,v in diff() do
	print(k,v)
end