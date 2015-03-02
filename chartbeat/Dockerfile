FROM ruby

RUN mkdir /app
ADD . /app

WORKDIR /app
RUN bundle install -j 4

CMD ["ruby", "chartbeat.rb"]
