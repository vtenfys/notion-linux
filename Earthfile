
deps:
    FROM node:15
    COPY build.sh .
    RUN apt update && \
        apt -y install p7zip-full imagemagick fakeroot wget python3 make && \
        npm -g install asar electron-packager electron-installer-debian

build:
    FROM +deps
    RUN wget 'https://desktop-release.notion-static.com/Notion%20Setup%202.0.10.exe' -O notion.exe && \
        ./build.sh win
    SAVE ARTIFACT out/notion-desktop_2.0.10-win_amd64.deb AS LOCAL out/notion-desktop_2.0.10-win_amd64.deb
