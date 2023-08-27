using Test

const Signal = UInt16

function parse_command(line)
    v = split(line, "->")
    sink = strip(v[2]) |> String
    source = strip(v[1])
    s_words = split(source, " ")

    if length(s_words) == 1
        return ["STORE", sink, String(s_words[1])]
    elseif length(s_words) == 2
        return ["NOT", sink, String(s_words[2])]
    elseif length(s_words) == 3
        return [String(s_words[2]), sink, String(s_words[1]), String(s_words[3])]
    end

    return ["INVALID", sink]
end


function number_or_value(state, key)
    if isdigit(key[1])
        return parse(Signal, key)
    elseif key in keys(state)
        return state[key]
    else
        return nothing
    end
end

function part1(commands)
    state = Dict{String, Signal}()

    # Store pass
    while !("a" in keys(state))
        for cmd in commands 
            if cmd[1] == "STORE"
                value = number_or_value(state, cmd[3])
                if !isnothing(value)
                    state[cmd[2]] = value
                end
            elseif cmd[1] == "NOT"
                value = number_or_value(state, cmd[3])
                if !isnothing(value)
                    state[cmd[2]] = ~value
                end
            elseif cmd[1] == "AND"
                vleft = number_or_value(state, cmd[3])
                vright = number_or_value(state, cmd[4])
                if !isnothing(vleft) && !isnothing(vright)
                    state[cmd[2]] = vleft & vright
                end
            elseif cmd[1] == "OR"
                vleft = number_or_value(state, cmd[3])
                vright = number_or_value(state, cmd[4])
                if !isnothing(vleft) && !isnothing(vright)
                    state[cmd[2]] = vleft | vright
                end
            elseif cmd[1] == "RSHIFT"
                vleft = number_or_value(state, cmd[3])
                vright = number_or_value(state, cmd[4])
                if !isnothing(vleft) && !isnothing(vright)
                    state[cmd[2]] = vleft >> vright
                end
            elseif cmd[1] == "LSHIFT"
                vleft = number_or_value(state, cmd[3])
                vright = number_or_value(state, cmd[4])
                if !isnothing(vleft) && !isnothing(vright)
                    state[cmd[2]] = vleft << vright
                end
            else
                error("unknown command")
            end
        end
    end


    return state
end


function tests()
end

function main()
    if length(ARGS) > 0
        path = ARGS[1]
        cmds = readlines(path) .|> parse_command
        state_1 = part1(cmds)
        println(state_1["a"])


        cmds_new = copy(cmds)
        for cmd in cmds_new
            if cmd[2] == "b"
                cmd[1] = "STORE"
                cmd[3] = Int(state_1["a"]) |> string
            end
        end
        state_2 = part1(cmds)
        println(state_2["a"])
    else
        tests()
    end
end

main()
