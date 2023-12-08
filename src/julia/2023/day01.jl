using AOC

const NUMBER_WORDS = Dict(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
)

function calibration_value(s; allow_words=false)
    # Digits 
    numbers = Tuple{Int64,Int64}[]
    for (i, char) in enumerate(s)
        if isdigit(char)
            push!(numbers, (i, parse(Int, char)))
        end
    end

    # Words
    if allow_words
        for key in keys(NUMBER_WORDS)
            ids = findall(key, s)
            for i in ids
                push!(numbers, (i[1], NUMBER_WORDS[key]))
            end
        end
    end

    # Sort and sum 
    sort!(numbers; by=first)

    return numbers[1][2] * 10 + numbers[end][2]
end

function main()
    path = AOC.data_dir("2023", "day01.txt")

    # Part 1
    value = 0
    for line in eachline(path)
        value += calibration_value(line)
    end
    println("Part 1: $value")

    # Part 2
    value_2 = 0
    for line in eachline(path)
        value_2 += calibration_value_2(line; allow_words=true)
    end
    println("Part 2: $value_2")
end