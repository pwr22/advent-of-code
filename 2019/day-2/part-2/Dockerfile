FROM perl

COPY . /build
WORKDIR /build
RUN curl -fsSL --compressed https://git.io/cpm | perl - install --global

CMD prove