FROM alpine:3.6

ENV ALPINE_VERSION=3.6

ENV PACKAGES="\
  dumb-init \
  musl \
  linux-headers \
  build-base \
  bash \
  git \
  gcc \
  g++ \
  curl\
  ca-certificates \
  python3 \
  python3 \
  openblas \
  openblas-dev \
  libstdc++ \
"

ENV PIP_PACKAGES="\
  dateparser \
  pandas \
  python-whois \
  requests \
  numpy==1.11.0 \
  scipy==0.18.0 \
  scikit-learn==0.18.1 \
  progressbar33 \
  blessings \
  pyasn \
  editdistance \
  pickles \
"


RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  # Install all the stuff we need for running AND compiling
  && apk add --no-cache $PACKAGES \
  # Install and upgrade Pip
  && pip3 install --upgrade pip \
  && ln -s /usr/include/locale.h /usr/include/xlocale.h \
  # Install and compile modules
  && pip3 install $PIP_PACKAGES \
  # Clean up and remove the stuff we do not need anymore
  && apk del curl g++ make musl-dev libc-dev git gcc build-base openblas-dev gfortran libc-utils --no-cache

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD /usr/bin/python
