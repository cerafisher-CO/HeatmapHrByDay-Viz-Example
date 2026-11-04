# hash:sha256:eccbf1ad33a2594d34eed56264b21040fb350f346c7a2e82b0524e59be552984
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/py-r:python3.12.8-R4.4.2-JupyterLab4.3.5-RStudiorstudio-server-2024.12.1-563-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-ask-pass /

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
        0xAD2323F17326AE31401037733E05EBFF05441C52 \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y 'deb http://deb.codeocean.com/shiny-server-jammy/ ubuntu main' \
    && apt-get purge -y --autoremove software-properties-common \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        pandoc=2.9.2.1-3ubuntu2 \
        shiny-server=1.5.23.1030 \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'remotes::install_version("ggplot2", "4.0.3")' \
    && Rscript -e 'remotes::install_version("dplyr", "1.2.1")' \
    && Rscript -e 'remotes::install_version("viridis", "0.6.5")' \
    && Rscript -e 'remotes::install_version("Interpol.T", "2.1.1")' \
    && Rscript -e 'remotes::install_version("lubridate", "1.9.5")' \
    && Rscript -e 'remotes::install_version("ggExtra", "0.11.0")' \
    && Rscript -e 'remotes::install_version("tidyr", "1.3.2")' \
    && Rscript -e 'remotes::install_version("shiny", "1.14.0")'
