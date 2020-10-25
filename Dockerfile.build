FROM debian:stable

ENV GOROOT=/usr/local/go-1.13
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH:$GOROOT/bin:$PATH

RUN apt-get update \
    && apt-get install -y nodejs npm wget bash build-essential cmake make curl git \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg \
        | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
        | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && wget https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz \
    && tar xf go1.13.9.linux-amd64.tar.gz \
    && mv go /usr/local/go-1.13 \
    && mkdir -p $HOME/go \
    && rm go1.13.9.linux-amd64.tar.gz

ENTRYPOINT ["bash"]
