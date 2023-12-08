using AOC
using Combinatorics

struct Hand
    raw::String
    counts::Dict{Char,Int}
    bid::Int
end

struct ScoredHand
    score::Int
    hand::Hand
end

function Hand(line::String)
    sl = split(line)
    hs = sl[1]
    bid = sl[2]

    counts = Dict{Char,Int}()
    for c in hs
        counts[c] = get(counts, c, 0) + 1
    end

    return Hand(hs, counts, parse(Int, bid))
end

function counts(d)
    c = zeros(Int, 5)

    for (_, v) in d
        c[v] += 1
    end

    return c
end

function score(h::Hand)
    c = counts(h.counts)

    c[5] == 0 || return 7 # five of a kind 
    c[4] == 0 || return 6 # four of a kind 

    # Full house
    if c[3] > 0 && c[2] > 0
        return 5
    end

    c[3] == 0 || return 4 # Three of a kind 
    c[2] < 2 || return 3 # Two pair 
    c[2] < 1 || return 2 # One pair 
    return 1 # High
end

function score_wild(h::Hand)
    nj = get(h.counts, 'J', 0)

    if nj == 0
        return score(h)
    end

    # Remove the jokers
    d = typeof(h.counts)()
    for (k, v) in h.counts
        k != 'J' || continue
        d[k] = v
    end

    cnts = counts(d)

    # Can make 4/5 of a kind 
    for k in 1:4
        if cnts[k] > 0 && (k + nj) >= 5
            return 7
        elseif cnts[k] > 0 && (k + nj) >= 4
            return 6 
        end
    end

    # Full House 
    if cnts[3] > 0
        if cnts[1] > 0
            return 5
        elseif nj > 1
            return 5
        end
    end

    # Three of a kind 
    if cnts[2] > 0
        return 4
    elseif nj > 1
        return 4
    end

    if nj > 1
        return 3
    end

    return 2
end


composition_count(n, k) = binomial(n + k - 1, n)

function next_composition!(x)
    kc = length(x)
    i = 0

    for j in kc:-1:1
        if 0 < x[j]
            i = j
            break
        end
    end

    if i == 0
        x[kc] = 1
        return
    end

    t = zero(eltype(x))
    im1 = 0

    if i == 1
        t = x[1] + 1
        im1 = kc
    elseif 1 < i
        t = x[i]
        im1 = i - 1
    end

    x[i] = 0
    x[im1] = x[im1] + 1
    x[kc] = x[kc] + t - 1

    return nothing
end

function compositions!(xc)
    kc = size(xc, 1)
    kc > 0 || error("invalid kc dimension")
    xc[:, 1] .= 0.0

    for k in 2:size(xc, 2)
        xc[:, k] .= xc[:, k-1]
        next_composition!(view(xc, :, k))
    end

    return nothing
end


function is_lt(a::ScoredHand, b::ScoredHand; wild=false)
    cscore = Dict(
        '2' => 2,
        '3' => 3,
        '4' => 4,
        '5' => 5,
        '6' => 6,
        '7' => 7,
        '8' => 8,
        '9' => 9,
        'T' => 10,
        'J' => wild ? 1 : 11,
        'Q' => 12,
        'K' => 13,
        'A' => 14
    )


    if a.score < b.score
        return true
    elseif a.score > b.score
        return false
    end

    h1 = a.hand.raw
    h2 = b.hand.raw

    for (aa, bb) in zip(h1, h2)
        if cscore[aa] < cscore[bb]
            return true
        elseif cscore[bb] < cscore[aa]
            return false
        end
    end

    return false
end


function main2()
    path = AOC.data_dir("2023", "day07.txt")
    hands = Hand.(eachline(path))
    shands = [ScoredHand(score(h), h) for h in hands]
    sort!(shands; lt=is_lt)
    p1 = sum(x -> x[1] * x[2].hand.bid, enumerate(shands))

    println("Part 1: $p1")

    shands2 = [ScoredHand(score_wild(h), h) for h in hands]
    sort!(shands2; lt=is_lt)
    p2 = sum(x -> x[1] * x[2].hand.bid, enumerate(shands2))
    println("Part 2: $p2")

    return nothing
end
