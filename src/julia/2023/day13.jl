using AOC

function symmetries(line::AbstractString)
    syms = Int[]
    for i in 2:length(line)
        is_sym = true
        for j in 1:(i-1)
            left_ind = i - j
            right_ind = i + j - 1
            right_ind <= length(line) || break
            if line[left_ind] != line[right_ind]
                is_sym = false
                break
            end
        end
        if is_sym
            push!(syms, i)
        end
    end

    return syms
end

function part1(pats)
    s = 0
    for pat in pats
        ss = symmetries.(pat)
        common = foldl(intersect, ss)

        # We have a horizontal symmetry
        if isempty(common)
            npat = String[]
            for i in 1:length(pat[1])
                push!(npat, join([a[i] for a in pat]))
            end
            s2 = symmetries.(npat)
            common = foldl(intersect, s2)
            s += 100 * (common[1] - 1)
        else
            s += common[1] - 1
        end
    end
    s
end

function part2(pats)
    t_pats = Vector{Vector{String}}()
    for pat in pats
        npat = String[]
        for i in 1:length(pat[1])
            push!(npat, join([a[i] for a in pat]))
        end
        push!(t_pats, npat)
    end

    ret = 0
    for pat in pats
        cnts = Dict{Int,Int}()
        for line in pat
            ss = symmetries(line)
            for s in ss
                cnts[s] = get(cnts, s, 0) + 1
            end
        end

        for (k, v) in cnts
            if v == length(pat) - 1
                ret += k - 1
            end
        end
    end

    for pat in t_pats
        cnts = Dict{Int,Int}()
        for line in pat
            ss = symmetries(line)
            for s in ss
                cnts[s] = get(cnts, s, 0) + 1
            end
        end
        for (k, v) in cnts
            if v == length(pat) - 1
                ret += 100 * (k - 1)
            end
        end
    end

    return ret
end

function read_patterns(file)
    pattern_lines = Vector{Vector{String}}()
    push!(pattern_lines, String[])
    for line in eachline(file)
        if isempty(line)
            push!(pattern_lines, String[])
        else
            push!(pattern_lines[end], line)
        end
    end
    pattern_lines
end

function load_patterns(path)
    lines = readlines(path)

    n = length(lines[1])
    m = findfirst(isempty, lines) - 1
    n_pats = div(length(lines) + 1, m + 1)
    mat = fill('.', m, n, n_pats)

    i = 1
    k = 1
    for line in lines
        if isempty(line)
            i = 1
            k += 1
            continue
        end

        for (j, c) in enumerate(line)
            mat[i, j, k] = c
        end
        i += 1
    end

    return mat
end

function main(test=false)
    path = AOC.data_dir("2023", test ? "day13-test.txt" : "day13.txt")
    pats = read_patterns(path)

    p1 = part1(pats)
    println("Part 1: $p1")

    part2(pats)

    load_patterns(path)
end