using Test

function tests()
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        lines = readlines(path)
    else
        tests()
    end
end

main()
