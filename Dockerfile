ARG BASE_IMAGE=rocker/verse:latest
FROM $BASE_IMAGE
# rocker/tidyverse:3.6.3
# bioconductor/bioconductor_docker:devel

LABEL org.opencontainers.image.source https://github.com/MaastrichtU-IDS/rstudio
# Rocker Dockerfile: https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/3.6.3.Dockerfile

ENV ADD=shiny
# ENV ROOT=true

## Install Shiny server
RUN /rocker_scripts/install_shiny_server.sh


##Install basic selection of packages
#RUN R -e "install.packages(c('BiocManager', 'corrgram', 'corrplot', 'd3heatmap', 'data.table', 'DescTools', 'devtools', 'doBy', 'dplyr', 'extrafont', 'extrafontdb', 'foreign', 'forestplot', 'forestploter', 'gdata', 'ggcorrplot', 'ggplot2', 'gtools', 'haven', 'igraph', 'jpeg', 'lattice', 'lubridate', 'meta', 'metafor', 'OpenMx', 'pheatmap', 'plyr', 'png', 'psych', 'randomForest', 'RColorBrewer', 'readxl', 'remotes', 'reshape', 'reshape2', 'rmarkdown', 'scatterplot3d', 'scales', 'sem', 'semTools', 'stringr', 'sysfonts', 'systemfonts', 'tibble', 'tidyr', 'ukbtools', 'VennDiagram', 'viridis', 'viridisLite', 'vroom', 'writexl', 'WriteXLS', 'xtable'), repos='https://cloud.r-project.org')"

RUN R -e "install.packages(c('BiocManager', 'devtools'), repos='https://cloud.r-project.org')"
#Sys.unsetenv("GITHUB_PAT")
RUN R -e "devtools::install_github('DudbridgeLab/avengeme')"
RUN R -e "devtools::install_github('MathiasHarrer/dmetar')"
RUN R -e "devtools::install_github('kassambara/easyGgplot2')"
RUN R -e "devtools::install_github('ramiromagno/gwasrapidd')"
RUN R -e "devtools::install_github('https://github.com/josefin-werme/LAVA.git')"
#Install postgwas from GitHub via devtools:
#setRepositories(ind = 1:6)
RUN R -e "devtools::install_github('merns/postgwas')"
RUN R -e "devtools::install_github('MRCIEU/TwoSampleMR')"
RUN R -e "devtools::install_github('ozancinar/poolR')"
RUN R -e "BiocManager::install('ASSET')"
RUN R -e "BiocManager::install('gwascat')"
RUN R -e "BiocManager::install('snpStats')"



## For R<4 : https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/add_shiny.sh
# COPY add_shiny.sh /etc/cont-init.d/add
# RUN bash /etc/cont-init.d/add

## Install ZSH cause permissions issues
# USER root
# RUN apt-get update -q && \
#     apt-get install -y zsh
# RUN chown -R rstudio:rstudio /usr/local
# RUN chown -R rstudio:rstudio /run
# USER rstudio

## Install Oh My ZSH! and custom theme
# RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# RUN wget -O /home/$NB_USER/.oh-my-zsh/custom/themes/biratime.zsh-theme https://raw.github.com/vemonet/biratime/main/biratime.zsh-theme
# RUN sed -i 's/^ZSH_THEME=".*"$/ZSH_THEME="biratime"/g' ~/.zshrc
# RUN echo 'setopt NO_HUP' >> ~/.zshrc
## Set default shell to ZSH
# ENV SHELL=/bin/zsh
# USER root
# RUN chsh -s /bin/zsh 
# USER rstudio

# Expose Shiny server
EXPOSE 3838
