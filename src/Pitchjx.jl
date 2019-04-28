module Pitchjx

export
    pitchjx

using EzXML
using DataFrames
using Dates

include("httprequest.jl")
include("extract.jl")

mutable struct Info
    result::DataFrame
end

"""
Scrape MLBAM pitchfx data.

# How to use

`pitchjx("2018-10-20")`
"""
function pitchjx(start, fin=start)
    @info "Initialize: Start"
    info = initinfo()
    @info "Initialize: Finish!"
    date = Date(start)
    findate = Date(fin)
    @info "Extract dataset: Start"
    while date <= findate
        df = extract(date)
        info.result = vcat(info.result, df)
        date += Dates.Day(1)
    end
    return info.result
end

function initinfo()
    return Info(
        DataFrame(
            date=String[],
            pitcherid=String[],
            pitcher_teamid=String[],
            pitcher_firstname=String[],
            pitcher_lastname=String[],
            pitcher_teamname=String[],
            pitcherthrow=String[],
            batterid=String[],
            batter_teamid=String[],
            batter_firstname=String[],
            batter_lastname=String[],
            batter_teamname=String[],
            batterstand=String[],
            eventdesc=String[],
            pitchresult=String[],
            x=String[],
            y=String[],
            px=String[],
            pz=String[],
            sztop=String[],
            szbottom=String[],
            pitchtype=String[],
            startspeed=String[],
            endspeed=String[],
            spindir=String[],
            spinrate=String[]
        )
    )
end

end
