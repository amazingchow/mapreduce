PROJECT      := github.com/amazingchow/mapreduce
SRC          := $(shell find . -type f -name '*.go' -not -path "./vendor/*, ./apps/*")
PB_SRC       := $(shell find . -type f -name '*.proto' -not -path "./vendor/*")
MASTER       := mapreduce-master-service
WORKER       := mapreduce-worker-service
ALL_TARGETS  := $(MASTER) $(WORKER)
APP          := $(shell pwd)/apps/wc.so

LDFLAGS += -X "$(PROJECT)/utils.Plugin=$(APP)"

all: build

build: clean $(ALL_TARGETS)

$(MASTER): $(SRC)
	go build $(GOMODULEPATH)/$(PROJECT)/cmd/$@

$(WORKER): $(SRC)
	go build -ldflags '$(LDFLAGS)' $(GOMODULEPATH)/$(PROJECT)/cmd/$@

lint:
	@golangci-lint run --skip-dirs=api --deadline=5m

pb-fmt:
	@clang-format -i ./pb/*.proto

test:
	go test -count=1 -v -p 1 $(shell go list ./ch/...| grep -v /vendor/)

clean:
	rm -f $(ALL_TARGETS)

.PHONY: all build clean
