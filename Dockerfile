FROM r-base

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python2 gdal-bin && \
    apt-get clean && apt-get autoremove -y

# install Sen2Cor
RUN wget http://step.esa.int/thirdparties/sen2cor/2.5.5/Sen2Cor-02.05.05-Linux64.run && \
    chmod +x Sen2Cor-02.05.05-Linux64.run && \
    mkdir bin && /bin/bash ./Sen2Cor-02.05.05-Linux64.run --nox11 --target ./bin && \
    rm -f ./Sen2Cor-02.05.05-Linux64.run

# install Python dependencies
RUN pip install -r requirements.txt

# install R dependencies
# RUN Rscript -e 'install.packages("raster")'

# install our code
COPY . .

CMD ["bin/s2_pipeline"]
