file = stream.log
image = part-1:bash

all: build $(file)

build:
	docker build -t $(image) .
clean:
	rm -f stream.log
stream:
	@docker run --rm -i $(image)
watch:
	@docker logs -f part-1
$(file):
	@echo ">> It may run longer then a minute."
	@echo ">> Run \"make watch\" meanwhile."
	docker run --rm -i --name part-1 $(image) > $(file)
