#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

pwd
echo "$0" $1

build()
{
  go clean

  echo "fetch dependencies"
  go get github.com/julienschmidt/httprouter
  go get github.com/potter0815/ipify-api/models
  go get github.com/rdegges/ipify-api/models
  go get github.com/rs/cors

  echo "build app"
  go build -a -v api/get_ip.go
  go build -a -v main.go
}

start()
{
  echo "start app"
  ./main
}

run()
{
  build
  start
}

docker_repository="potter0815/go-myip"

dockerize()
{


  docker build -t go-myip .
  imageid=$(docker images | grep $docker_repository | grep latest  |awk '{print ($3)}')
  docker tag -f $imageid $docker_repository:latest
  docker push $docker_repository
}

dockerpush()
{
  docker push $docker_repository
}

case $1 in
    build) echo "build"
        build
        exit
        ;;
    dockerize) echo "dockerize (build & push)"
        dockerize
        exit
        ;;
    dockerpush) echo "dockerize (build & push)"
        dockerize
        exit
        ;;
    run) echo "run (build & start)"
        run
        ;;
    * ) echo "no argument use: build|dockerize|run "
        start
        exit
        ;;
esac
