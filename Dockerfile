FROM node:buster
RUN apt-get update
RUN apt-get install -y p7zip-full
RUN apt-get install -y sudo
RUN apt-get install -y fakeroot
RUN apt-get install -y rpm
RUN apt-get install -y aptly
RUN apt-get install -y python3-apt
RUN apt-get install -y yum-utils
RUN apt-get install -y createrepo
RUN npm install -g firebase-tools
RUN curl -L https://fly.io/install.sh | FLYCTL_INSTALL=/usr sh
