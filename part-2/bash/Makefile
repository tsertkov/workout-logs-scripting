file = stream.png
image = part-2:bash

all: build $(file)

build:
	docker build -t $(image) .
clean:
	rm -f $(file)
stream:
	@docker run --rm -i $(image)
$(file):
	@docker run --rm -i $(image) < ../../part-1/bash/stream.log > $(file)
