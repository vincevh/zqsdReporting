FROM r-base


RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  libmariadb-client-lgpl-dev

RUN R -e 'install.packages(c("devtools"))'
RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN R -e "install.packages('broom')"
RUN R -e 'install.packages("RMySQL")'
RUN R -e 'install.packages("yaml")'
RUN R -e 'install.packages("jsonlite")'

EXPOSE 8000

WORKDIR /app
ADD ./app /app


ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
CMD ["/app/slackAPI.R"]
