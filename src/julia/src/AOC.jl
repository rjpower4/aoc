module AOC

"""
    project_dir()
    project_dir(subs...)

Return the path to the AOC project optionally appending sub paths.
"""
project_dir() = dirname(dirname(dirname(@__DIR__)))
project_dir(subs...) = joinpath(project_dir(), subs...)

"""
    data_dir()

Return the path to the AOC data directory optionally appending sub paths.
"""
data_dir(subs...) = project_dir("data", subs...)


end
