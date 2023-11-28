
local enc = {}

enc.rand_arr = {}
enc.rand_counter = 1
enc.rand_size = 128 * 4
enc.iterations = 0
enc.gen_counter = 0

enc.gen_rand = function(seed)
    local m = 2^32
	local a = 1664525
	local c = 1013904223

	seed = seed + enc.gen_counter
	enc.gen_counter = enc.gen_counter +1

    return math.ceil(((a * seed + c) % m) / m * 255)
end

enc.get_rand = function()
    if enc.rand_counter > enc.rand_size then
        enc.rand_counter = 1
	end

    enc.rand_counter = enc.rand_counter + 1

    return enc.rand_arr[enc.rand_counter-1]
end

enc.split_string = function(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end

    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, tonumber(str))
    end
    return t
end

enc.is_acceptable = function(nums) 
    local function isUpperCaseAscii(number)
		return number >= 65 and number <= 90
    end

    local function isLowerCaseAscii(number)
		return number >= 97 and number <= 122
    end

    local function is_viable_part(number)
		return isUpperCaseAscii(number) or isLowerCaseAscii(number)
    end
	    
	--[[local matches = 4
	    
	if not is_viable_part(nums[1]) then
    	print("1 was not okay!: ",nums[1])
    	matches = matches -1
	end
	
	if not is_viable_part(nums[2]) then
		print("2 was not okay!: ",nums[2])
		matches = matches -1
	end
	
	if not is_viable_part(nums[3]) then
		print("3 was not okay!: ",nums[3])
		matches = matches -1
	end
	
	if not is_viable_part(nums[4]) then
		print("4 was not okay!: ",nums[4])
		matches = matches -1
	end
	
	print("End of iteration: ",matches, " Matches!")]]
	    
	return is_viable_part(nums[1]) and is_viable_part(nums[2]) and is_viable_part(nums[3]) and is_viable_part(nums[4]) 
end

local function wrap_num(num, lower_lim, upper_lim)
	if num > upper_lim then
		num = num - (upper_lim - lower_lim + 1)
	end
	    
	if num < lower_lim then
		num = num + (upper_lim - lower_lim + 1)
	end

    return num
end

enc.mut_nums = function(n1, n2, n3, n4)
    n1 = wrap_num(n1 + enc.get_rand(), 0, 255)
    n2 = wrap_num(n2 + enc.get_rand(), 0, 255)
    n3 = wrap_num(n3 + enc.get_rand(), 0, 255)
    n4 = wrap_num(n4 + enc.get_rand(), 0, 255)

    return {n1, n2, n3, n4}
end

enc.encode = function(address,seed) 
	math.randomseed(seed)

	for i=1,enc.rand_size do
		enc.rand_arr[i] = enc.gen_rand(seed)
	end

	local numbers = enc.split_string(address,".")

	while not enc.is_acceptable(numbers) do
	    numbers = enc.mut_nums(numbers[1], numbers[2], numbers[3], numbers[4])
	    enc.iterations = enc.iterations + 1
	    --print("Iteration:", enc.iterations)
	end

	local ret_iters = enc.iterations

	enc.rand_arr = {}
	enc.rand_counter = 1
	enc.rand_size = 128 * 4
	enc.iterations = 0
	enc.gen_counter = 0

	return string.char(numbers[1])..string.char(numbers[2])..string.char(numbers[3])..string.char(numbers[4])..ret_iters
end

enc.decode = function(code, seed)
    local chars = code:sub(1, 4)
    local iters = tonumber(code:sub(5, #code))

    math.randomseed(seed)

    for i=1,enc.rand_size do
		enc.rand_arr[i] = enc.gen_rand(seed)
	end

    local numbers = {
        string.byte(code:sub(1, 1)),
        string.byte(code:sub(2, 2)),
        string.byte(code:sub(3, 3)),
        string.byte(code:sub(4, 4))
    }

    for i = 1,iters do
        numbers[1] = wrap_num(numbers[1] - enc.get_rand(), 0, 255)
        numbers[2] = wrap_num(numbers[2] - enc.get_rand(), 0, 255)
        numbers[3] = wrap_num(numbers[3] - enc.get_rand(), 0, 255)
        numbers[4] = wrap_num(numbers[4] - enc.get_rand(), 0, 255)
    end

   	enc.rand_arr = {}
	enc.rand_counter = 1
	enc.rand_size = 128 * 4
	enc.iterations = 0
	enc.gen_counter = 0


    return numbers[1] .. "." .. numbers[2] .. "." .. numbers[3] .. "." .. numbers[4]
end


return enc