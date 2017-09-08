FROM ruby
WORKDIR /app
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
		
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime	

ADD ./app/Gemfile /app/Gemfile
RUN bundle install


ADD app /app


EXPOSE 3000
