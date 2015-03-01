FROM ruby:2.1.2
MAINTAINER David Blooman <david.blooman@gmail.com>

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update
RUN gem install linkey --no-rdoc --no-ri

CMD [ "irb" ]
