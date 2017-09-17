FROM ruby
WORKDIR /app


ENV RAILS_RELATIVE_URL_ROOT /sr

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
		
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime	


ADD app /app

RUN bundle install


EXPOSE 3000


CMD rails server -b 0.0.0.0
