FROM ruby:2.5.3
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		apt-transport-https && \
	echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" >> /etc/apt/sources.list && \
	echo "deb https://repo.sovrin.org/sdk/deb xenial stable" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88  && \
	apt-get update && \
	apt-get install -y --allow-unauthenticated --no-install-recommends \
		indy-cli && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV RAILS_ROOT $WORKDIR
COPY Gemfile /usr/src/app/

RUN bundle install
RUN gem install bundler

COPY . .

RUN bundle update && \
	ln -s $PWD/script/init.sh /bin/init.sh

CMD ["./script/run.sh"]

EXPOSE 3000
