FROM r-base

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python2 python-pip gdal-bin file musl-dev && \
    apt-get clean && apt-get autoremove -y

# install Sen2Cor
RUN wget http://step.esa.int/thirdparties/sen2cor/2.5.5/Sen2Cor-02.05.05-Linux64.run && \
    mkdir bin && /bin/bash ./Sen2Cor-02.05.05-Linux64.run --quiet --nox11 --target bin/sen2cor && \
    rm -f ./Sen2Cor-02.05.05-Linux64.run

# install Python dependencies
COPY requirements.txt ./
RUN pip install -r requirements.txt

# install R dependencies
# RUN Rscript -e 'install.packages("raster")'

# install our code
COPY . .

ENV PATH="/app/bin:/app/sen2cor/bin:${PATH}"
ENV S2_USER
ENV S2_PASS
ENV S2_AOI
ENV S2_START
ENV S2_END
ENV S2_OUTDIR
ENV S2_CLOUDCOVERAGE

CMD ["bin/s2_pipeline", "-a", "${S2_AOI}", "-s", "${S2_START}", "-e", "${S2_END}", "-o", "${S2_OUTDIR}", "-c", "${S2_CLOUDCOVERAGE}"]
