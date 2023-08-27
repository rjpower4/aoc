using Test
using MD5

function search(key, starting)
    number = 1
    while !startswith(bytes2hex(md5("$(key)$(number)")), starting)
        number += 1
    end
    return number
end


function tests()
    @test search("abcdef", "00000") == 609043
    @test search("pqrstuv", "00000") == 1048970
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        key = read(path, String) |> strip
        println(search(key, "00000"))
        println(search(key, "000000"))
    else
        tests()
    end
end

main()
