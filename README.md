![pitchjx](./pitchjx.png)

Tools for extracting Statcast pitching data.

## Note  
Be sure this package no longer supports PITCH f/x data. This package name has been inspired by [pitchRx](https://github.com/cpsievert/pitchRx), but MLB has ended PITCH f/x support. 

## Install

```bash
julia -e 'using Pkg; Pkg.add("Pitchjx")'
```

## How to use

### Extract specific date's pitching data

```julia
using Pitchjx

data = pitchjx("2018-10-20")
```

### Extract Multiple dates' pitching data

This is recommended for getting short range dates' data.

```julia
using Pitchjx

data = pitchjx("2018-10-20", "2018-10-22")
```

### Extract Multople dates' pitching data with multiprocessing

This is recommended for getting long range dates' data (faster than previous way).

```julia
using Distributed
@everywhere using Pitchjx

Distributed.addprocs(2)

dates = ["2018-07-01", "2018-07-02", "2018-07-03", "2018-07-04"]
# get datas as DataFrame's array
result = pmap(d -> pitchjx(d), dates)
```

## Reference

- [The Anatomy of a Pitch:Doing Physics with PITCHf/x Data](http://baseball.physics.illinois.edu/KaganPitchfx.pdf)
- [Statcast Search CSV Documentation | baseballsavant.com](https://baseballsavant.mlb.com/csv-docs)