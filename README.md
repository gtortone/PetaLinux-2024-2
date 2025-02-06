# Dockerfile for Petalinux

This is a Petalinux docker file.
You need to download petalinux 2024.2 from Xilinx.  
You can download the petalinux with aria2c which enables multipart download.  

This project based on Ubuntu 24.04.  
Docker Ubuntu version is 24.04 LTS.
Petalinux is 2024.2.  

Use Vivado Tools on your Linux Machine and use petalinux with docker.  

## Important Issue
You have to download petalinux-2024.2-final-installer.run file at this project location.

## How to accelerate download
```
# aria2c -m 10 -s 10 -x 10 -o petalinux-v2024.2-final-installer.run <petalinux link>
```

## Building docker image
```
$ docker build --build-arg PETALINUX_INSTALLER=petalinux-v2024.2-final-installer.run -t petalinux2024_2 .
```

## Run docker container
```
$ docker run -it --name pl-2024.2 -v $HOME:/home/vivado/workshop --mount type=bind,source=/run/media,target=/run/media,bind-propagation=shared petalinux2024_2
```

## how to know what commands are currently running on docker
```
$ docker ps --no-trunc
```
