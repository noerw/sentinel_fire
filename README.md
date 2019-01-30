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

### Options/Arguments
<a name="options"></a>

| argument  | short  | value  | default  | description  |
|---|---|---|---|---|
| --help   | -h  | -  |  - | show brief help  |
| --aoi  |  -a | geojson json file  | -  |  area of interest as geojson polygon geometry. Required. |
| --algorithm  |  - | dnbr\|bais2  | dnbr and bais2  | select single algorithm. If not specified, dnbr AND bais2 will be run.  |
| --start | -s | YYYYMMDD\|NOW-XDAYS | `NOW` | start date |
| --end | -e | YYYYMMDD\|NOW-XDAYS | `NOW-5DAYS` | end date|
| --outdir | -o | directory | `./` | path to output directory |
| --cloudcoverage | -c | Number | `20` | maximum percentage of allowed cloud coverage. |
| --cleanup| - | - |-  | remove intermediate results after processing, if flag is set |

### Scripts

All scripts are available under `./bin/` and will be called in order of appearance in table below. Change detection algorithms are located under `./changeDetection/`.

| name | description  |
|---|---|
| **Scripts** | |
| s2_pipeline | Main entrypoint for Sentinel_fire. Starts the whole pipeline. |
| s2_query | Prepares the download. Searches matching tiles and skips download for already downloaded files. |
| s2_download | Downloads satellite imagery from Copernicus Apihub. |
| s2_preprocess | Preprocesses the images using sen2cor. |
| s2_grouporbit | Groups orbits by date. Needed in case the aoi is located at the dateline. |
| s2_clip | Stitches all images of a group and clips them to the aoi. |
| s2_changedetection | Handles the options of the different change detection algorithms and calls them. |
| s2_visualize | Creates html files displaying the computed images. |
| **Change Detection**| |
| dNBR | Computes the difference normalized burn ratio of two images. |
| BAIS2 | Computes the BAIS2 of a single image. |
| waterDetection | Removes water bodies from an image. |

## Development

### Adding changeDetection scripts

 1. Add script file to `./changeDetection`
 1. Add script options to `s2_changeDetection`

### Adding scripts to the pipeline

 1. Add script file to `./bin` (make sure to specify path to executable in first line)
 1. Add script options to `s2_pipeline` at according processing step.

## Contact Us
For any queries, difficulties in installation and/or usage please contact one of the team.

- [Albert Hamzin](https://github.com/Albertios)
- [Christopher Rohtermundt](https://github.com/CRoh)
- [Jan Suleiman](https://github.com/jansule)
- [Jonathan Bahlmann](https://github.com/jonathom)
- [Norwin](https://github.com/noerw)
- [Raoul Kanschat](https://github.com/rkans02)
- [Yousef Qamaz](https://github.com/YouQam)

## License
GPL-3.0
