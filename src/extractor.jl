using HTTP, DataFrames, Dates, MLBStatsAPI


function extract(params)
    result = DataFrame(
        date = String[],
        pitcherid = Int64[],
        pitcher_teamid = Int64[],
        pitcher_firstname = String[],
        pitcher_lastname = String[],
        pitcher_teamname = String[],
        pitcherthrow = String[],
        batterid = Int64[],
        batter_teamid = Int64[],
        batter_firstname = String[],
        batter_lastname = String[],
        batter_teamname = String[],
        batterstand = String[],
        eventdesc = String[],
        pitchresult = String[],
        x = Float64[],
        y = Float64[],
        px = Float64[],
        pz = Float64[],
        pfxx = Float64[],
        pfxz = Float64[],
        zone = Int64[],
        sztop = Float64[],
        szbottom = Float64[],
        pitchtype = String[],
        startspeed = Float64[],
        endspeed = Float64[],
        spindir = Float64[],
        spinrate = Float64[],
        nasty = Float64[]
    )
    schedule = schedulemlb(params)
    for date in schedule["dates"]
        games = date["games"]
        for g in games
            gameparams = Dict(
                "gamePk" => g["gamePk"]
            )
            feed = game(gameparams)
            gamedate = split(feed["metaData"]["timeStamp"], "_")[1]
            roster = feed["gameData"]["players"]
            plays = feed["liveData"]["plays"]["allPlays"]
            for play in plays
                pitcherid = play["matchup"]["pitcher"]["id"]
                pitcherteamid = play["about"]["halfInning"] == "top" ? feed["gameData"]["teams"]["home"]["id"] : feed["gameData"]["teams"]["away"]["id"]
                pitcherteamname = play["about"]["halfInning"] == "top" ? feed["gameData"]["teams"]["home"]["name"] : feed["gameData"]["teams"]["away"]["name"]
                pitcherfn = roster["ID" * string(pitcherid)]["firstName"]
                pitcherln = roster["ID" * string(pitcherid)]["lastName"]
                pitcherthrow = play["matchup"]["pitchHand"]["code"]
                batterid = play["matchup"]["batter"]["id"]
                batterteamid = play["about"]["halfInning"] == "top" ? feed["gameData"]["teams"]["away"]["id"] : feed["gameData"]["teams"]["home"]["id"]
                batterteamname = play["about"]["halfInning"] == "top" ? feed["gameData"]["teams"]["away"]["name"] : feed["gameData"]["teams"]["home"]["name"]
                batterfn = roster["ID" * string(batterid)]["firstName"]
                batterln = roster["ID" * string(batterid)]["lastName"]
                batterstand = play["matchup"]["batSide"]["code"]
                eventdesc = play["result"]["description"]
                events = play["playEvents"]
                for event in events
                    ispitch = event["isPitch"]
                    if !ispitch
                        @warn "This row will be skipped from result dataframe due to non-pitch record."
                        continue
                    end
                    pitchresult = event["details"]["description"]
                    if haskey(event, "pitchData")
                        try
                            x = event["pitchData"]["coordinates"]["x"]
                            y = event["pitchData"]["coordinates"]["y"]
                            px = event["pitchData"]["coordinates"]["pX"]
                            pz = event["pitchData"]["coordinates"]["pZ"]
                            pfxx = event["pitchData"]["coordinates"]["pfxX"]
                            pfxz = event["pitchData"]["coordinates"]["pfxZ"]
                            zone = event["pitchData"]["zone"]
                            sztop = event["pitchData"]["strikeZoneTop"]
                            szbottom = event["pitchData"]["strikeZoneBottom"]
                            pitchtype = event["details"]["type"]["code"]
                            startspeed = event["pitchData"]["startSpeed"]
                            endspeed = event["pitchData"]["endSpeed"]
                            spinrate = event["pitchData"]["breaks"]["spinRate"]
                            spindir = event["pitchData"]["breaks"]["spinDirection"]
                            nasty = 0
                            push!(result, [
                                gamedate,
                                pitcherid,
                                pitcherteamid,
                                pitcherfn,
                                pitcherln,
                                pitcherteamname,
                                pitcherthrow,
                                batterid,
                                batterteamid,
                                batterfn,
                                batterln,
                                batterteamname,
                                batterstand,
                                eventdesc,
                                pitchresult,
                                x,
                                y,
                                px,
                                pz,
                                pfxx,
                                pfxz,
                                zone,
                                sztop,
                                szbottom,
                                pitchtype,
                                startspeed,
                                endspeed,
                                spinrate,
                                spindir,
                                nasty
                            ])
                        catch
                            @warn "At least one column data cannot be extracted. This row will be skipped from result dataframe."
                            continue
                        end
                    end
                end
            end
        end
    end
    return result
end
