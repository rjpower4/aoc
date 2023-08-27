using Test

struct Present
    l::Int
    w::Int
    h::Int
end

function Base.parse(::Type{Present}, s::String)
    v = parse.(Int, split(s, 'x'))
    return Present(v[1], v[2], v[3])
end

side_areas(p::Present) = (p.l*p.w, p.w*p.h, p.h*p.l)
perimeters(p::Present) = 2 .* (p.l + p.w, p.w + p.h, p.h + p.l)
surface_area(p::Present) = 2sum(side_areas(p))
volume(p::Present) = p.l * p.w * p.h
paper_required(p::Present) = surface_area(p) + minimum(side_areas(p))
ribbon_required(p::Present) = minimum(perimeters(p)) + volume(p)

part1(data) = mapfoldl(x -> paper_required(parse(Present, x)), +, data)
part2(data) = mapfoldl(x -> ribbon_required(parse(Present, x)), +, data)

function tests()
    @test parse(Present, "2x3x4") == Present(2, 3, 4)
    @test parse(Present, "1x1x10") == Present(1, 1, 10)

    @test paper_required(Present(2, 3, 4)) == 58
    @test paper_required(Present(1, 1, 10)) == 43

    @test ribbon_required(Present(2, 3, 4)) == 34
    @test ribbon_required(Present(1, 1, 10)) == 14
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        data = readlines(path)
        println(part1(data))
        println(part2(data))
    else
        tests()
    end
end

main()
