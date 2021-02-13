FROM node:buster
RUN apt-get update
RUN apt-get install -y p7zip-full
RUN apt-get install -y sudo
RUN apt-get install -y fakeroot
RUN apt-get install -y rpm
