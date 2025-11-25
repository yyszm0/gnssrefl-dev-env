# 2025 jan 29 trying python 3.10 again
# important ! https://endoflife.date/debian
FROM python:3.10-slim-bookworm
# this does work but i don't think i need to go to python 3.11 yet
#FROM python:3.11-slim-bullseye
#FROM python:3.10-slim-buster 
#FROM python:3.9-slim-buster 
#FROM python:3.8-slim-buster 
LABEL maintainer="EARTHSCOPE"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

# build requirements
RUN apt-get update
RUN apt-get install -y gfortran python3-pip unzip wget vim git openssh-client

#RUN apt-get update && \
#  apt-get install -y gfortran python3-pip unzip wget vim 

## executables
RUN mkdir -p /etc/gnssrefl/exe /etc/gnssrefl/orbits /etc/gnssrefl/refl_code/Files /etc/gnssrefl/notebooks
COPY gnssrefl/vendor/gfzrnx_2.0-8219_armlx64 /etc/gnssrefl/exe/
COPY gnssrefl/vendor/gfzrnx_2.0-8219_lx64 /etc/gnssrefl/exe/

RUN if [ "$TARGETARCH" = "arm64" ] ; then \
  cp /etc/gnssrefl/exe/gfzrnx_2.0-8219_armlx64 /etc/gnssrefl/exe/gfzrnx; else \
  cp /etc/gnssrefl/exe/gfzrnx_2.0-8219_lx64 /etc/gnssrefl/exe/gfzrnx; \
  fi

RUN chmod +x /etc/gnssrefl/exe/gfzrnx

COPY gnssrefl/vendor/crx2rnx.c /etc/gnssrefl/exe/
COPY gnssrefl/vendor/rnx2crx.c /etc/gnssrefl/exe/
RUN cd /etc/gnssrefl/exe && \
  gcc -ansi -O2 crx2rnx.c -o CRX2RNX \
  && gcc -ansi -O2 rnx2crx.c -o RNX2CRX

ENV PATH="/etc/gnssrefl/exe:$PATH" 

# should not be needed
#RUN pip install numpy --upgrade --ignore-installed
COPY gnssrefl/pyproject.toml gnssrefl/README.md gnssrefl/meson.build /usr/src/gnssrefl/
#COPY pyproject.toml README.md setup.py /usr/src/gnssrefl/
COPY gnssrefl/gnssrefl /usr/src/gnssrefl/gnssrefl
# might as well install this EGM 96 file
COPY gnssrefl/gnssrefl/EGM96geoidDATA.mat /etc/gnssrefl/refl_code/Files
COPY gnssrefl/notebooks/learn-the-code /etc/gnssrefl/notebooks/learn-the-code
COPY gnssrefl/notebooks/use-cases /etc/gnssrefl/notebooks/use-cases
RUN pip3 install --no-cache-dir /usr/src/gnssrefl
RUN pip3 install meson-python ninja

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

ENV EXE=/etc/gnssrefl/exe
ENV ORBITS=/etc/gnssrefl/refl_code
#ENV ORBITS=/etc/gnssrefl/orbits
ENV REFL_CODE=/etc/gnssrefl/refl_code
ENV DOCKER=true

# i don't believe these commands do anything useful.
# I don't think we need station_pos.db anymore either, just the 2024 one. 
RUN mkdir -p /etc/gnssrefl/refl_code/input/
RUN cp /usr/src/gnssrefl/gnssrefl/gpt_1wA.pickle /etc/gnssrefl/refl_code/input/
# I do not think this is needed.  Checking out that hypothesis 
# RUN cp /usr/src/gnssrefl/gnssrefl/station_pos.db /etc/gnssrefl/refl_code/Files/
RUN cp /usr/src/gnssrefl/gnssrefl/station_pos_2024.db /etc/gnssrefl/refl_code/Files/

WORKDIR /usr/src/gnssrefl

# For develop: gnssrefl packages should be binded and editable
COPY ./gnssrefl-dev-env/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
