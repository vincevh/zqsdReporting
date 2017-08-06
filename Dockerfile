FROM r-base
WORKDIR /app
ADD . /app
RUN apt-get update
RUN apt-get -y install libssl-dev
RUN apt-get -y install curl
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install libssh2-1-dev
RUN ["Rscript", "INSTALL_DEP.R"]
CMD ["sh", "runRepApp.sh"]