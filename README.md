# rmswuq-docker
Docker image for the Rocky Mountain Summer Workshop on Uncertainty Quantification

This image contains a virtual Ubuntu OS with  the most stable release of FEniCS and BET.

To install Docker:

   On Mac OS X or Windows:
      Install boot2docker (http://boot2docker.io/). 
      Launch boot2docker (which will start the Docker daemon).

   On Linux:
      Instructions for installation and starting the Docker daemon for different versions of Linux can be found here: https://docs.docker.com/installation/ubuntulinux/.

To get the image (this may take several minutes):
```
docker pull smattis/rmswuq-docker
```
To launch the container:
```
docker run -t -i smattis/rmswuq-docker:latest
```

To share a specified directory from the host with the container:
```
docker run -v /absolute/path/to/shared/directory:/home/rmswuq/shared \ 
-t -i smattis/rmswuq-docker:latest
```
The script `rmswuq` in this repo is usefuly for running this container. Move the file to the directory in which you want to work and do
```
./rmswuq
```
This will launch the container and share a subdirectory called `shared`.

If you are running on Ubuntu, you can also share your display with the container using X11 forwarding by
```
./rmswuq -gui 
```
