FROM rocker/verse:3.6.0

RUN apt-get update -qq && apt-get -y install \
  libssl-dev \
  pandoc

RUN install2.r --error \
    --deps TRUE \
    pagedown \
    tidyverse \
    glue

COPY . /home/rstudio/resume
