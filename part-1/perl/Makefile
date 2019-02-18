file = stream.log
image = part-1:perl

all: build $(file)
build:
	docker build -t $(image) .
clean:
	rm -f $(file)
stream:
	@docker run --rm -i $(image)
stream.log:
	docker run --rm -i $(image) > $(file)
