using Test

const VOWELS = "aeiou"

struct NiceCheck1 end
struct NiceCheck2 end

function isnice(::Type{NiceCheck1}, word)
    n_vowels = 0
    found_twice = false
    last_char = '\0'

    for char in word
        if char in VOWELS
            n_vowels += 1
        end

        if !found_twice && last_char == char
            found_twice = true
        end

        if char == 'b' || char == 'd' || char == 'q' || char == 'y'
            if (Int(char) - Int(last_char)) == 1
                return false
            end
        end

        last_char = char
    end

    return (n_vowels >= 3) && found_twice
end


code(a::Char) = Int(a) - Int('a')
code(a::Char, b::Char) = code(a) * 26 + code(b) + 1

function isnice(::Type{NiceCheck2}, word)
    c0 = '\0'
    c1 = '\0'
    pairs = zeros(Int, code('z', 'z'))


    twice = false
    skip_repeat = false

    for (i, char) in enumerate(word)
        if !skip_repeat && c0 == char && c1 != char
            skip_repeat = true
        end

        if !twice && isletter(c1)
            idx = code(c1, char)

            if pairs[idx] == 0
                pairs[idx] = i
            elseif (i - pairs[idx]) > 1
                twice = true
            end
        end

        c0 = c1
        c1 = char
    end

    return skip_repeat && twice
end

function tests()
    @test isnice(NiceCheck1, "ugknbfddgicrmopn") == true
    @test isnice(NiceCheck1, "aaa") == true
    @test isnice(NiceCheck1, "jchzalrnumimnmhp") == false
    @test isnice(NiceCheck1, "haegwjzuvuyypxyu") == false
    @test isnice(NiceCheck1, "dvszwmarrgswjxmb") == false
    @test isnice(NiceCheck1, "aaaba") == false
    @test isnice(NiceCheck1, "xibilzssabuqihtq") == false
    @test isnice(NiceCheck1, "iabomphsuyfptoos") == false
    @test isnice(NiceCheck1, "cpkabmaahbnlrhiz") == false
    @test isnice(NiceCheck1, "fnvabvxeiqvsarqq") == false
    @test isnice(NiceCheck1, "uabepbrrnxfbpyvx") == false


    @test isnice(NiceCheck2, "qjhvhtzxzqqjkmpb") == true
    @test isnice(NiceCheck2, "xxyxx") == true
    @test isnice(NiceCheck2, "aaabxb") == false
    @test isnice(NiceCheck2, "uurcxstgmygtbstg") == false
    @test isnice(NiceCheck2, "ieodomkazucvgmuy") == false

end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        lines = readlines(path)
        println(count(x -> isnice(NiceCheck1, x), lines))
        println(count(x -> isnice(NiceCheck2, x), lines))
    else
        tests()
    end
end

main()
