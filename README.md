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

```julia
using Pitchjx

data = pitchjx("2018-10-20", "2018-10-22")
```

## Reference

- [The Anatomy of a Pitch:Doing Physics with PITCHf/x Data](http://baseball.physics.illinois.edu/KaganPitchfx.pdf)
- [Statcast Search CSV Documentation | baseballsavant.com](https://baseballsavant.mlb.com/csv-docs)