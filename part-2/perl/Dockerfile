FROM perl:latest

WORKDIR /app
ADD cpanfile /app
RUN \
  set -e; \
  apt-get update; \
  apt-get install -y libgd-dev; \
  rm -rf /var/lib/apt/lists/*; \
  cpanm --installdeps .

ADD stream2graph.pl /app
ENTRYPOINT [ "/app/stream2graph.pl" ]
