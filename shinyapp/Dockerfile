FROM r-base
WORKDIR /app
RUN apt-get update && apt-get install -y \
        libssl-dev \
        curl \
        libcurl4-openssl-dev \
		libssh2-1-dev
ADD INSTALL_DEP.R /app
RUN ["Rscript", "INSTALL_DEP.R"]
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
ADD app /app

EXPOSE 1337

CMD R -e "shiny::runApp('.',host= '0.0.0.0', port = 1337)"