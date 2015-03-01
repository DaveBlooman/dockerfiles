FROM ubuntu:14.04
MAINTAINER David Blooman <david.blooman@gmail.com>

RUN apt-get update

RUN apt-get install -y wget openjdk-6-jre openjdk-6-jre-headless

RUN wget http://archive.apache.org/dist/jmeter/binaries/apache-jmeter-2.11.tgz
RUN tar xf apache-jmeter-2.11.tgz
RUN rm apache-jmeter-2.11.tgz
RUN mv apache-jmeter-2.11 /usr/local/jmeter

ENV PATH /usr/local/jmeter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

EXPOSE 1099
EXPOSE 4445

CMD apache-jmeter-2.11/bin/jmeter
