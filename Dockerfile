# Dynamic agents
FROM docker:dind

# you can specify python version during image build
ARG PYTHON_VERSION=3.11.0
ENV LIBRD_VER=2.6.1
# install build dependencies and needed tools
RUN apk add --no-cache \
    curl \
    jq \
    git \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev \
    sqlite-dev \
    nodejs \
    npm

RUN apk add --no-cache --virtual .make-deps bash make wget git gcc g++ && apk add --no-cache musl-dev zlib-dev openssl zstd-dev pkgconfig libc-dev
RUN wget https://github.com/edenhill/librdkafka/archive/v${LIBRD_VER}.tar.gz
RUN tar -xvf v${LIBRD_VER}.tar.gz && cd librdkafka-${LIBRD_VER} && ./configure --prefix /usr && make && make install
RUN export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig/
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig/

RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \                                              
    && tar xzf Python-${PYTHON_VERSION}.tgz

# build python with SQLite support and remove left-over sources
# build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \ 
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf
COPY ./git-credentials /home/jenkins/.git-credentials
RUN git config --global credential.helper store && \
    git config --global --add safe.directory '*'