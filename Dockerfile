FROM jupyter/scipy-notebook
MAINTAINER Bryan K Woods <bryan.k.woods@gmail.com>

# if you can use the stable xgboost, just conda install
# RUN conda install xgboost

# but we want some features from master for this demo
USER root
RUN apt-get update && apt-get install -y cmake
USER jovyan
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    cd ../python-package && \
    python setup.py install && \
    cd ../.. && \
    rm -fr xgboost

# add our notebooks and execute them
COPY notebooks/* work/
RUN jupyter nbconvert --to notebook --execute work/*.ipynb
