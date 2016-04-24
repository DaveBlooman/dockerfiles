Example Cloudformation Docker App
==================


Cloudformation that creates an EC2 instance with an ELB, elastic load balancer, which uses a Docker container to serve a hello world app.

### App

Sinatra app using Ruby.  Two routes, / and /status

### Docker Container

Uses standard Ruby image

### Cloudformation

Using user data, the docker package is installed, started and used to pull the correct image.  The image is then run as a container.
