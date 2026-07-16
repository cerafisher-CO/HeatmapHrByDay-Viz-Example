# hash:sha256:45bf46887cdda7b58d7237b8e72f1b51101a5e67f19505b4bad6dec40f8b9abd
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/py-r:python3.12.8-R4.4.2-JupyterLab4.3.5-RStudiorstudio-server-2024.12.1-563-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-ask-pass /

RUN Rscript -e 'remotes::install_version("ggplot2")' \
    && Rscript -e 'remotes::install_version("dplyr")' \
    && Rscript -e 'remotes::install_version("viridis")' \
    && Rscript -e 'remotes::install_version("Interpol.T")' \
    && Rscript -e 'remotes::install_version("lubridate")' \
    && Rscript -e 'remotes::install_version("ggExtra")' \
    && Rscript -e 'remotes::install_version("tidyr")'
