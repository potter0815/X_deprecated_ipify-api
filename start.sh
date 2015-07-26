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
  #go get github.com/rdegges/ipify-api/models
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
#docker_repository="go-myip"

dockerize()
{

  echo "building...."
  #docker build -t go-myip .
  docker build -t $docker_repository .
  imageid=$(docker images | grep ^$docker_repository | grep latest  |awk '{print ($3)}')
  echo "docker tag -f $imageid $docker_repository:latest"
  docker tag -f $imageid $docker_repository:latest
  #docker push $docker_repository
}

dockerpush()
{
  dockerize
  echo "pushing image..."
  docker push $docker_repository
}

case $1 in
    build) echo "build"
        build
        exit
        ;;
    dockerize) echo "dockerize (build)"
        dockerize
        exit
        ;;
    dockerpush) echo "dockerize (build & push)"
        dockerpush
        exit
        ;;
    run) echo "run (build & start)"
        run
        exit
        ;;
    * ) echo "no argument use: build|run|dockerize|dockerpush "
        start
        exit
        ;;
esac
