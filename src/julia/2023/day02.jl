using AOC

struct Game 
    blue::Int64
    red::Int64
    greeen::Int64 
end

function Base.parse(::Type{Game}, s::AbstractString)
    reds = findall(r"\d+ red", s)
end


function main()
    path = AOC.data_dir("2023", "day02.txt")
end