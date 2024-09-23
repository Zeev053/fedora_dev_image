# Fedora Docker Image

Create docker image for development 
The docker image is based on fedora:40 docker image  

## with docker build (in git bash)
~~~
docker build --progress plain -t zeevb053/fedora-dev:14.03 . 2>&1 |  tee res.txt  
docker push zeevb053/fedora-dev:14.03
~~~


To run the docker  
~~~
docker run --name dev-image -v c:\temp\.ssh:/temp -p 2025:22 zeevb053/fedora-dev:14.03
~~~

## Build Centos with gcc 8.5 
~~~
docker build --progress plain  -f Dockerfile_gcc8.5 -t zeevb/dev_docker:C_14.02__gcc8.5 . 2>&1 |  tee res_gcc8.5.txt
docker push zeevb/dev_docker:C_14.02__gcc8.5
~~~
