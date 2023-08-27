using Test
using AOC
using DataStructures

function check(new, old)
    for i = 1:length(old)
        for j = (i+1):length(old)
            if old[i] + old[j] == new
                return true
            end
        end
    end
    return false
end

function part1(nums, n)
    buffer = CircularBuffer{eltype(nums)}(n)
    for (i, value) in enumerate(nums)
        if i > n
            check(value, buffer) || return value
        end
        push!(buffer, value)
    end
    return 0
end

function part2(nums, target)
    start_ind = 1
    while true 
        stop_ind = start_ind
        total = nums[start_ind]
        while true 
            stop_ind += 1 
            total += nums[stop_ind]
            total != target || return sum(extrema(view(nums, start_ind:stop_ind)))
            total < target || break
        end
        start_ind += 1
        start_ind <= length(nums) || return 0
    end
    return 0
end

function tests()
end

function main()
    tests()
    path = AOC.data_dir("2020", "day09.txt")
    values = readlines(path) .|> x -> parse(Int, x)
    val = part1(values, 25)
    val_2 = part2(values, val)
    println("Part 1: $(val)")
    println("Part 2: $(val_2)")
end

main()
