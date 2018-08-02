# Docker images listed at https://github.com/docker-library/official-images/blob/master/library/golang
FROM golang:1.10.3-stretch
# FROM golang:1.10.3-alpine3.8
# FROM golang:1.10.3-windowsservercore-1803
ARG PROJECT=github.com/joshgav/go-web

RUN mkdir /app # for built artifacts
RUN mkdir -p $GOPATH/src/${PROJECT}
WORKDIR $GOPATH/src/${PROJECT}

# better for build cache to specify necessary files
ADD ["Gopkg.*","main.go", "./"]
RUN go get -u -v github.com/golang/dep/cmd/dep && dep ensure -v
RUN go build -v -o /app/server .

CMD ["/app/server"]
