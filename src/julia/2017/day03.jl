@enum Direction Left Right Up Down

function turn(dir)
    return if dir == Left
        Down
    elseif dir == Right
        Up
    elseif dir == Up
        Left
    elseif dir == Down
        Right
    end
    error("unknown direction")
end

function step(dir, loc)
    s = if dir == Left
        (-1, 0)
    elseif dir == Right
        (1, 0)
    elseif dir == Up
        (0, 1)
    elseif dir == Down
        (0, -1)
    end
    return loc .+ s
end

function walk_to_n(n)
    loc = (0, 0)
    dir = Right
    cnt = 1
    first = true
    val = 1

    while val < n
        for _ in 1:cnt
            loc = step(dir, loc)
            val += 1
            if val == n
                return loc
            end
        end

        dir = turn(dir)

        if !first
            cnt += 1
        end
        first = !first
    end
    loc
end

function surrounding(loc)
    a, b = loc
    return (
    (a + 1, b),
    (a - 1, b),
    (a, b + 1),
    (a, b - 1),
    (a + 1, b + 1),
    (a + 1, b - 1),
    (a - 1, b - 1),
    (a - 1, b + 1),
    )
end

function part2(value)
    board = Dict((0, 0) => 1)
    n = 2
    last_val = 0

    while last_val < value
        loc = walk_to_n(n)
        adj = surrounding(loc)
        last_val = 0
        for l in adj
            if l in keys(board)
                last_val += board[l]
            end
        end
        board[loc] = last_val
        n += 1
    end

    last_val
end


function main()
    value = read(ARGS[1], String) |> x -> parse(Int, x)
    loc_1 = walk_to_n(value)
    p1 = sum(abs, loc_1)
    p2 = part2(value)

    println("Part 1: $(p1)")
    println("Part 2: $(p2)")
end
main()
