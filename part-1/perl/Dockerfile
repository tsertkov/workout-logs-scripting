FROM perl:latest

ADD cpanfile .
RUN cpanm --installdeps .
ADD emit-logs.pl /

ENTRYPOINT [ "/emit-logs.pl" ]
