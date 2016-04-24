FROM ruby:2.2.2

RUN mkdir /app
ADD . /app

WORKDIR /app
RUN bundle install -j 4

EXPOSE 9292
