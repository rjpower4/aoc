using AOC


function main3()
    path = AOC.data_dir("2023", "day03-test.txt")
    lines = readlines(path)
    mat = fill('.', length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        for (j, char) in enumerate(line)
            mat[i, j] = char
        end
    end

    mat
end