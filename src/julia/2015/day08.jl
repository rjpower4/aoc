using Test

function char_count(s) 
    v = 0
    i = 2

    while i < length(s)
        if s[i] == '\\'
            i += 1
            if s[i] == '\\'
                v += 1
            elseif s[i] == '"'
                v += 1
            elseif s[i] == 'x'
                v += 1
                i += 3
            end
        else
            v += 1
        end

        i += 1
    end
    return v
end

f1(s) = length(s) - char_count(s)

function tests()
    @test char_count("\"\"") == 0
    @test char_count("\"abc\"") == 3
    @test char_count("\"abc\\\"aaa\"") == 7
    @test char_count("\"\\x27\"") == 1

    @test length("\"\"") == 2
    @test length("\"abc\"") == 5
    @test length("\"abc\\\"aaa\"") == 10
    @test length("\"\\x27\"") == 6

    @test f1("\"\"") == 2
    @test f1("\"abc\"") == 2
    @test f1("\"abc\\\"aaa\"") == 3
    @test f1("\"\\x27\"") == 5

    strs = ["\"\"", "\"abc\"", "\"abc\\\"aaa\"", "\"\\x27\""]
    @test mapfoldl(f1, +, strs) == 12
end



function main()
    if length(ARGS) > 0
        path = ARGS[1]
        lines = readlines(path)
        mapfoldl(f1, +, lines) |> println
    else
        tests()
    end
end

main()
