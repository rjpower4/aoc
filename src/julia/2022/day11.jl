using AOC: data_dir

part2(path) = 0

pint(s) = parse(Int64, s)

function perform_op(op, old)
    v1 = old
    v2 = op[end] == "old" ? old : pint(op[end])
    d = Dict(:+ => Base.:+, :* => Base.:*)
    return d[op[1]](v1, v2)::Int64
end

function load_input(path)
    lines = readlines(path)
    n_monkeys = Int64((length(lines) + 1) / 7)
    ops = Vector{Tuple{Symbol, String, String}}(undef, n_monkeys)
    items = Vector{Vector{Int64}}(undef, n_monkeys)
    dtest = zeros(Int64, n_monkeys)
    throws = zeros(Int64, n_monkeys, 2)

    cap1(x) = x.captures[1]
    get_num(line) = match(r"(\d+)", line).captures[1] |> pint

    io = open(path, "r")
    for k in 1:n_monkeys
        readline(io)
        items[k] = eachmatch(r"(\d+)", readline(io)) |> collect .|> cap1 .|> pint

        a, op, b = split(readline(io)[20:end])
        ops[k] = (Symbol(op), a, b)

        dtest[k] = get_num(readline(io))
        throws[k, 1] = get_num(readline(io))
        throws[k, 2] = get_num(readline(io))
        k != n_monkeys && readline(io)
    end

    return items, ops, dtest, throws
end

function solve(path, n, method)
    items, ops, dtest, throws = load_input(path)
    m = setup(method, items, ops, dtest, throws)
    counts = zeros(Int64, length(items))

    for _ in 1:n
        for (monkey, (item_set, op, dt, t)) in enumerate(zip(items, ops, dtest,
                                                             eachrow(throws)))
            for item in (item_set)
                val = perform_op(op, item)
                val = process(method, val, m)
                to_ind = mod(val, dt) == 0 ? t[1] : t[2]
                push!(items[to_ind + 1], val)
                counts[monkey] += 1
            end
            empty!(item_set)
        end
    end

    s = sort(counts)
    return s[end] * s[end - 1]
end

struct DivideByThree end
setup(::DivideByThree, items, ops, dtest, throws) = nothing
process(::DivideByThree, val, _) = floor(val / 3) |> Int64

struct GcdModulus end
setup(::GcdModulus, items, ops, dtest, throws) = prod(dtest)
process(::GcdModulus, v, x) = mod(v, x)

function main()
    path = data_dir("day-11-02.txt")
    println("Part 1: $(solve(path, 20, DivideByThree()))")
    println("Part 2: $(solve(path, 10_000, GcdModulus()))")
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end