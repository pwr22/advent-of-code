FROM perl

# cpm is much faster
RUN cpanm --notest App::cpm

# start of by only copying across the list of dependencies and install them as a layering optimisation
WORKDIR /deps
COPY cpanfile .
RUN cpm install --global

# now copy across everything else, build, test and install
WORKDIR /build
COPY . .
RUN prove -lvj8 && perl Makefile.PL && make install

CMD for prog in /usr/local/bin/advent_2020_perl_*; do $prog; done