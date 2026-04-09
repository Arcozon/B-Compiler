FROM ubuntu:22.04
 
RUN apt-get update 
RUN apt-get install -y \
    bison \
    flex \
    make
 
WORKDIR /project
 
CMD ["make"]
