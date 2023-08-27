using Test

part1(data) = count('(', data) - count(')', data)
@test part1("(())") == 0
@test part1("(((") == 3
@test part1("(()(()(") == 3

function part2(data)
    loc = 0
    for (i, c) in enumerate(data)
        if c == '('
            loc += 1
        elseif c == ')'
            loc -= 1
        end

        loc != -1 || return i
    end
end

@test part2(")") == 1
@test part2("()())") == 5

function main()
    path = ARGS[1]
    data = read(path, String)
    println(part1(data))
    println(part2(data))
end

main()
