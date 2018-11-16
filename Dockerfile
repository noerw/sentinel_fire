FROM r-base

RUN apt-get update && \
    apt-get install -y libssl-dev libcurl3-dev libgdal-dev libgeos-dev libproj-dev libudunits2-dev liblwgeom-dev \
    libcairo2-dev libjq-dev libprotobuf-dev protobuf-compiler libv8-dev aria2 libnetcdf-dev

RUN apt-get clean && apt-get autoremove -y

# install R dependencies
RUN Rscript -e 'install.packages("devtools")'
# https://stackoverflow.com/a/52992040
RUN Rscript -e 'devtools::install_version("rgeos", version = "0.3-28")'

RUN Rscript -e 'install.packages("sf")'
RUN Rscript -e 'devtools::install_github("ranghetti/sen2r", upgrade = "never")'

RUN Rscript -e 'sen2r::install_sen2cor()'

# install script
WORKDIR /app
COPY . .

CMD ["Rscript", "meppen_crop.R"]
