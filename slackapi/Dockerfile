FROM trestletech/plumber
MAINTAINER Docker User <docker@user.org>

WORKDIR /app
RUN R -e "install.packages('broom')"

ADD ./app /app
CMD ["/app/slackAPI.R"]