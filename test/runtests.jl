using Test
using Pitchjx
using DataFrames

# test for no game day.
empty = DataFrame(
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

@test pitchjx("2018-01-01") == empty
