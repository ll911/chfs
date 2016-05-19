FROM node:onbuild
MAINTAINER leo.lou@gov.bc.ca

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g bower grunt-cli \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \  
  && rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ll911/chfs.git /tmp/repo1 && cp -r /tmp/repo1/* /usr/src/app && rm -Rf /tmp/repo1
RUN npm install
RUN grunt

RUN useradd -ms /bin/bash chfs \
  && chown -R chfs:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER chfs
WORKDIR /usr/src/app
EXPOSE 8080
CMD node app.js -p 8080
