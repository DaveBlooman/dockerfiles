FROM ubuntu
MAINTAINER David Blooman <david.blooman@gmail.com>

ADD lein /bin/lein
RUN chmod +x /bin/lein

RUN mkdir -p /var/logs/riemann

# Install dependencies
RUN apt-get update
RUN apt-get install -y curl default-jre-headless git wget

# Download the latest .deb and install
RUN curl https://aphyr.com/riemann/riemann_0.2.8_all.deb > /tmp/riemann_0.2.8_all.deb
RUN dpkg -i /tmp/riemann_0.2.8_all.deb


RUN git clone https://github.com/pyr/riemann-extra.git
RUN cd riemann-extra && lein uberjar

# Expose the ports for inbound events and websockets
EXPOSE 5555
EXPOSE 5555/udp
EXPOSE 5556

# Share the config directory as a volume
VOLUME /etc/riemann
ADD riemann /etc/default/riemann
ONBUILD COPY riemann.config /etc/riemann/riemann.config


# Set the hostname in /etc/hosts so that Riemann doesn't die due to unknownHostException
CMD echo 127.0.0.1 $(hostname) > /etc/hosts; /usr/bin/riemann /etc/riemann/riemann.config
