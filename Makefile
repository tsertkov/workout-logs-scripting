all: all-perl
all-perl:
	(cd part-1/perl && make clean all)
	(cd part-2/perl && make clean all)
	(cd part-3/perl && make clean all)
all-bash:
	(cd part-1/bash && make clean all)
	(cd part-2/bash && make clean all)
all-python:
	(cd part-1/python && make clean all)
	(cd part-2/python && make clean all)
	(cd part-3/python && make clean all)
stream-bash:
	@rm -rf stream-artifacts/*
	@echo ">> Building all artifacts with streams (using bash)."
	@/usr/bin/env bash -c '\
		(cd part-1/bash && make stream) | tee \
			>stream-artifacts/stream.log \
			>(cd part-2/bash && make stream > ../../stream-artifacts/graph.png) \
			>(cd part-3/perl && make stream > ../../stream-artifacts/topwords.tsv) \
	'
	@echo ">> Done. See files in artifacts/ directory."
stream-perl:
	@rm -rf stream-artifacts/*
	@echo ">> Building all artifacts with streams (using perl)."
	@/usr/bin/env bash -c '\
		(cd part-1/perl && make stream) | tee \
			>stream-artifacts/stream.log \
			>(cd part-2/perl && make stream > ../../stream-artifacts/graph.png) \
			>(cd part-3/perl && make stream > ../../stream-artifacts/topwords.tsv) \
	'
	@echo ">> Done. See files in stream-artifacts/ directory."
stream-python:
	@rm -rf stream-artifacts/*
	@echo ">> Building all artifacts with streams (using python)."
	@/usr/bin/env bash -c '\
		(cd part-1/python && make stream) | tee \
			>stream-artifacts/stream.log \
			>(cd part-2/python && make stream > ../../stream-artifacts/graph.png) \
			>(cd part-3/python && make stream > ../../stream-artifacts/topwords.tsv) \
	'
	@echo ">> Done. See files in stream-artifacts/ directory."
all-browser:
	@open js-all-in-one/index.html
