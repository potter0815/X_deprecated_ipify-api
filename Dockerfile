FROM golang:1.4.2-onbuild

MAINTAINER potter

ADD main.go /var/server/main.go

EXPOSE 3000

CMD ["go", "run", "/var/server/main.go"]
