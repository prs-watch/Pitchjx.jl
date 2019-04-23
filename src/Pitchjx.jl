module Pitchjx

export
    pitchjx

using HTTP
using EzXML
using DataFrames
using Dates

mutable struct Info
    players::DataFrame
    pitches::DataFrame
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
        @info "Extract: "  date  ": Start"
        year = Dates.year(date)
        month = lpad(Dates.month(date), 2, "0")
        day = lpad(Dates.day(date), 2, "0")
        base = "https://gd2.mlb.com/components/game/mlb/year_$year/month_$month/day_$day"
        gidlist = gethtml(base)
        for li in findall("//li/a/text()",gidlist)
            litext = strip(li.content)
            if occursin(r"gid_*", litext)
                getplayers(base, litext, date, info.players)
                getpitches(base, litext, date, info.pitches)
            end
        end
        @info "Extract " date ": Finish!"
        date += Dates.Day(1)
    end
    @info "Extract dataset: Finish!"
    @info "Process dataset: Start"
    processdf = join(info.pitches, info.players, on=(:pitcherid, :id), kind=:inner, makeunique=true)
    resultdf = join(processdf, info.players, on=(:batterid, :id), kind=:inner, makeunique=true)
    resultdf = rename(resultdf, [
            :firstname => :pitcher_firstname,
            :lastname => :pitcher_lastname,
            :teamname => :pitcher_teamname,
            :teamid => :pitcher_teamid,
            :firstname_1 => :batter_firstname,
            :lastname_1 => :batter_lastname,
            :teamname_1 => :batter_teamname,
            :teamid_1 => :batter_teamid,
        ]
    )
    @info "Process dataset: Finish!"
    return resultdf[
        [
            :date,
            :pitcherid,
            :pitcher_teamid,
            :pitcher_firstname,
            :pitcher_lastname,
            :pitcher_teamname,
            :pitcherthrow,
            :batterid,
            :batter_teamid,
            :batter_firstname,
            :batter_lastname,
            :batter_teamname,
            :batterstand,
            :eventdesc,
            :pitchresult,
            :x,
            :y,
            :px,
            :pz,
            :sztop,
            :szbottom,
            :pitchtype,
            :startspeed,
            :endspeed,
            :spindir,
            :spinrate
        ]
    ]
end

function initinfo()
    return Info(
        DataFrame(
            date = String[],
            id = String[],
            firstname = String[],
            lastname = String[],
            teamid = String[],
            teamname = String[]
        ),
        DataFrame(
            date = String[],
            pitcherid = String[],
            batterid = String[],
            pitcherthrow = String[],
            batterstand = String[],
            eventdesc = String[],
            pitchresult = String[],
            x = String[],
            y = String[],
            px = String[],
            pz = String[],
            sztop = String[],
            szbottom = String[],
            pitchtype = String[],
            startspeed = String[],
            endspeed = String[],
            spindir = String[],
            spinrate = String[]
        )
    )
end

function gethtml(url)
    r = HTTP.get(url)
    if 200 <= r.status < 300
        return root(parsehtml(String(r.body)))
    else
        error("Page is not accessable.")
    end
end

function getxml(url)
    r = HTTP.get(url)
    if 200 <= r.status < 300
        return root(parsexml(String(r.body)))
    else
        error("Page is not accessable.")
    end
end

function getplayers(base, gid, date, df)
    url = base * "/" * gid * "players.xml"
    players = getxml(url)
    for player in findall("//player", players)
        try
            id = player["id"]
            firstname = player["first"]
            lastname = player["last"]
            teamid = player["team_id"]
            teamname = player["team_abbrev"]
            push!(df, [Dates.format(date, "yyyy-mm-dd"), id, firstname, lastname, teamid, teamname])
        catch
            @warn "player tag " pitch " is not extractable."
        end
    end
end

function getpitches(base, gid, date, df)
    url = base * "/" * gid * "inning/inning_all.xml"
    pitches = getxml(url)
    for atbat in findall("//atbat", pitches)
        pitcherid = atbat["pitcher"]
        batterid = atbat["batter"]
        pitcherthrow = atbat["p_throws"]
        batterstand = atbat["stand"]
        eventdesc = atbat["des"]
        for pitch in findall("//pitch", atbat)
            try
                pitchresult = pitch["des"]
                x = pitch["x"]
                y = pitch["y"]
                px = pitch["px"]
                pz = pitch["pz"]
                sztop = pitch["sz_top"]
                szbottom = pitch["sz_bot"]
                pitchtype = pitch["pitch_type"]
                startspeed = pitch["start_speed"]
                endspeed = pitch["end_speed"]
                spindir = pitch["spin_dir"]
                spinrate = pitch["spin_rate"]
                push!(df, [
                    Dates.format(date, "yyyy-mm-dd"),
                    pitcherid,
                    batterid,
                    pitcherthrow,
                    batterstand,
                    eventdesc,
                    pitchresult,
                    x,
                    y,
                    px,
                    pz,
                    sztop,
                    szbottom,
                    pitchtype,
                    startspeed,
                    endspeed,
                    spindir,
                    spinrate
                    ]
                )
            catch
               @warn "pitch tag " pitch " is not extractable."
            end
        end
    end
end

end
