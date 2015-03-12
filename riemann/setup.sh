docker pull davey/riemann
docker pull revett/collectd

cd docker-riemann/onbuild
docker build -t bbcnews/riemann .

docker run -d --name=riemann -p 5555:5555 -p 5555:5555/udp -p 5556:5556 davey/riemann
docker run -d --name=collectd -e CONFIG_TYPE=riemann -p 8125:8125/udp -e EP_HOST=192.168.59.103 -e EP_PORT 5555 --link=riemann:riemann revett/collectd
