FROM r-base

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python2 python-pip proj-bin libproj-dev libgdal-dev gdal-bin file musl-dev && \
    apt-get clean && apt-get autoremove -y

# install Sen2Cor
RUN wget http://step.esa.int/thirdparties/sen2cor/2.5.5/Sen2Cor-02.05.05-Linux64.run && \
    mkdir bin && /bin/bash ./Sen2Cor-02.05.05-Linux64.run --quiet --nox11 --target bin/sen2cor && \
    rm -f ./Sen2Cor-02.05.05-Linux64.run

# install Python dependencies
COPY requirements.txt ./
RUN pip install -r requirements.txt

# install R dependencies
RUN Rscript -e 'install.packages(c("raster", "rgdal"))'

# install our code
COPY . .

# yes, i know.
ENV S2_USER norwin
ENV S2_PASS duDIdu43da51

CMD ["bin/s2_pipeline", "--help"]
