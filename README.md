# sentinel_fire
Burned area detection on Sentinel 2 imagery for monitoring of conflict areas.

> Study project at [ifgi](https://ifgi.de), winter term 2018.

## how to run it

This application is best started via Docker / docker-compose.
If you want to run it natively instead, please follow the installation steps outlined in the `Dockerfile`.

To install the application, run:
```
docker-compose build s2
```

Then, to start processing, run:
```
docker-compose run s2 bin/s2_pipeline <arguments>
```

Try `--help` for an overview of available options.

The pipeline will then run, starting to work:
- tile search
- image download
- preprocessing L1C -> L2A
- image stitching & clipping
- change detection
- visualization
- cleanup

## License
GPL-3.0
