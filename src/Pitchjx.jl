module Pitchjx

export pitchjx

using DataFrames, Dates

include("extractor.jl")

"""
Scrape pitching data.

# How to use

`pitchjx("2018-10-20")`
"""
function pitchjx(start, fin=start)
    @info "Initialize: Start"
    params = Dict(
        "startDate" => start,
        "endDate" => fin,
        "sportId" => 1
    )
    @info "Initialize: Finish!"
    @info "Extract dataset: Start"
    result = extract(params)
    @info "Extract dataset: Finish!"
    return result
end

end
