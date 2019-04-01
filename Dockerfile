# based on https://hub.docker.com/r/jackfirth/racket/dockerfile
FROM debian
MAINTAINER Hao Xu <xuhao@renci.org>

RUN apt-get update && \
    apt-get install -y wget sqlite3 git && \
    rm -rf /var/lib/apt/lists/*

ENV RACKET_VERSION 7.2
ENV RACKET_INSTALLER_URL http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-$RACKET_VERSION-x86_64-linux.sh

RUN wget --output-document=racket-install.sh $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

RUN git clone https://github.com/webyrd/mediKanren.git
# COPY semmed.csv /mediKanren/code
RUN cp /mediKanren/code/sample_semmed.csv /mediKanren/code/semmed.csv
WORKDIR /mediKanren/code
RUN mkdir semmed
RUN racket csv-semmed-ordered-unique-enum.rkt semmed.csv semmed
RUN racket csv-semmed-simplify.rkt semmed.csv semmed
RUN racket semmed-index-predicate.rkt semmed

CMD ["racket"]