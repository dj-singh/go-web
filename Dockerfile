FROM gobuffalo/buffalo:v0.10.2 as builder

RUN mkdir -p ${GOPATH%%:*}/src/github.com/joshgav/go-web
WORKDIR $GOPATH/src/github.com/joshgav/go-web

ADD package.json .
ADD yarn.lock .
RUN yarn install --no-progress
ADD . .
RUN dep ensure
RUN buffalo build --static -o /bin/app


FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache ca-certificates

WORKDIR /bin/
COPY --from=builder /bin/app .

EXPOSE 3000
CMD exec /bin/app
