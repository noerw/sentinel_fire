# Sentinel_fire 💣🔥🛰
> Burned area detection on Sentinel 2 imagery for monitoring of conflict areas.

This project was developed in the scope of the study project "Monitoring Conflict Areas with Satellite Image Time Series" winter term 2018, at [ifgi] as the concluding assignment.

[ifgi]: https://ifgi.de

## how to run it

This application is best started via [docker] / [docker-compose].
If you want to run it natively instead, please follow the installation steps outlined in the `Dockerfile`.

[docker]: https://docs.docker.com/
[docker-compose]: https://docs.docker.com/compose/

To install the application, run:
```
docker-compose build s2
```

Then, to start processing, run:
```
docker-compose run s2 bin/s2_pipeline <arguments>
```

Try `--help` for an overview of available options.

The pipeline will then run, starting to work on the following tasks
- tile search
- image download
- preprocessing L1C -> L2A
- image stitching & clipping
- change detection
- visualization
- cleanup

## Data

## Installation

## Input: Sentinel_fire

## Contact Us
For any queries, difficulties in installation and/or usage please contact one of the team.

- Albert Hamzin
- Christopher Rohtermundt
- Jan Suleiman
- Jonathan Bahlmann
- @noerw
- Raoul Kanschat
- Yousef Qamaz

## License
GPL-3.0
