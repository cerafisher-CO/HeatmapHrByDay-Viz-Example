# hash:sha256:0bcc5a6c5d9ac3eaa65b129e831d467de5f68a77e3bff9c5d6ba62adc7a0a4fe
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/py-r:python3.12.8-R4.4.2-JupyterLab4.3.5-RStudiorstudio-server-2024.12.1-563-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-ask-pass /

RUN Rscript -e 'remotes::install_version("ggplot2", "4.0.3")' \
    && Rscript -e 'remotes::install_version("dplyr", "1.2.1")' \
    && Rscript -e 'remotes::install_version("viridis", "0.6.5")' \
    && Rscript -e 'remotes::install_version("Interpol.T", "2.1.1")' \
    && Rscript -e 'remotes::install_version("lubridate", "1.9.5")' \
    && Rscript -e 'remotes::install_version("ggExtra", "0.11.0")' \
    && Rscript -e 'remotes::install_version("tidyr", "1.3.2")'
