FROM ruby:3.2.1-bullseye
LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN apt-get install -y git

RUN gem install rails \
    && npm i -g yarn

