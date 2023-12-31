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
    cc = copy(h.counts)
    delete!(cc, 'J')

    mk = if isempty(keys(cc))
        'K'
    else
        first(keys(cc))
    end
    m = 0
    for (k, v) in cc
        if v > m
            mk = k
            m = v
        end
    end

    cc[mk] = m + nj

    @show hh = Hand(h.raw, cc, h.bid)
    return score(hh)
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


function main2(test=false)
    path = AOC.data_dir("2023", test ? "day07-test.txt" : "day07.txt")
    hands = Hand.(eachline(path))
    shands = [ScoredHand(score(h), h) for h in copy(hands)]
    sort!(shands; lt=is_lt)
    p1 = sum(x -> x[1] * x[2].hand.bid, enumerate(shands))

    println("Part 1: $p1")

    islt2(a, b) = is_lt(a, b; wild=true)
    shands2 = [ScoredHand(score_wild(h), h) for h in hands]
    sort!(shands2; lt=islt2)
    p2 = sum(x -> x[1] * x[2].hand.bid, enumerate(shands2))
    println("Part 2: $p2")

    return nothing
end
