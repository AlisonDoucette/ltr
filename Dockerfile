FROM jupyter/scipy-notebook
MAINTAINER Bryan K Woods <bryan.k.woods@gmail.com>

# if you can use the stable xgboost, just conda install
# RUN conda install xgboost

USER root
RUN apt-get update && apt-get install -y cmake unrar
USER jovyan

# but we want some features from master for this demo
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    cd ../python-package && \
    python setup.py install && \
    cd ../..

# download the MQ2008 demo data and stage to the data directory
RUN cd xgboost/demo/rank && \
    ./wgetdata.sh && \
    mkdir -p ~/work/data && \
    mv mq2008* ~/work/data && \
    cd ../../.. && \
    rm -fr xgboost

# add our notebooks and execute them
COPY notebooks/* work/
