using AOC

function compute_path(loc, instructions, locs)
    cur = loc
    steps = 0
    visited = [cur]
    for next in Iterators.cycle(instructions)
        steps += 1

        index = if next == 'L'
            1
        else
            2
        end

        cur = locs[cur][index]
        if steps > 1
            if cur in visited
                push!(visited, cur)
                break
            end
            push!(visited, cur)
        end
    end

    visited
end

function scratch(instructions, locs)
    current = String[]
    final = String[]
    for key in keys(locs)
        if key[end] == 'A'
            push!(current, key)
        elseif key[end] == 'Z'
            push!(final, key)
        end
    end

    periods = Int[]

    for cur in current
        steps = 0
        last = -1

        for letter in Iterators.cycle(instructions)
            if cur[end] == 'Z'
                if last > 0
                    push!(periods, steps - last)
                    break
                else
                    last = steps
                end
            end

            steps += 1
            if letter == 'L'
                cur = locs[cur][1]
            elseif letter == 'R'
                cur = locs[cur][2]
            end
        end
    end

    lcm(periods)
end

function part_2_2(instructions, locs)
    current = String[]
    final = String[]
    for key in keys(locs)
        if key[end] == 'A'
            push!(current, key)
        elseif key[end] == 'Z'
            push!(final, key)
        end
    end

    paths = [
        compute_path(l, instructions, locs) for l in current
    ]

    z_offsets = Vector{Int}[]
    for path in paths
        zo = Int[]
        for (i, l) in enumerate(path)
            @show l
            if l[end] == 'Z'
                push!(zo, i - 1)
            end
        end

        push!(z_offsets, zo)
    end

    z_offsets
end

function part_2(instructions, locs)
    current = String[]
    final = String[]
    for key in keys(locs)
        if key[end] == 'A'
            push!(current, key)
        elseif key[end] == 'Z'
            push!(final, key)
        end
    end

    paths = [
        compute_path(l, instructions, locs) for l in current
    ]

    return paths

    println(current)
    println(final)
    return

    steps = 0
    for next in Iterators.cycle(instructions)
        all_good = true
        for c in current
            if c[end] != 'Z'
                all_good = false
                break
            end
        end


        if all_good
            break
        end

        steps += 1

        index = if next == 'L'
            1
        else
            2
        end

        for i in 1:length(current)
            current[i] = locs[current[i]][index]
        end
        println(steps)
    end

    return steps
end


function main()
    path = AOC.data_dir("2023", "day08.txt")
    text = readlines(path)

    instructions = text[1]
    d = Dict{String,Tuple{String,String}}()
    for line in text[3:end]
        (a, b, c) = match(r"([A-Z0-9]+) = .([A-Z0-9]+), ([A-Z0-9]+)", line).captures
        d[a] = (b, c)
    end

    steps = 0
    cur = "AAA"
    for letter in Iterators.cycle(instructions)
        if cur == "ZZZ"
            break
        end

        steps += 1
        if letter == 'L'
            cur = d[cur][1]
        elseif letter == 'R'
            cur = d[cur][2]
        end
    end

    println("Steps: $steps")

    scratch(instructions, d)
end