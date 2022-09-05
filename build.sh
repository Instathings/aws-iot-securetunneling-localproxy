#! /bin/bash
image=aws-localproxy
tag=latest
copy=0

usage() {
    echo "$0 [--tag=VALUE] [--image=VALUE]"
}


while true; do
    case "$1" in
        --image|-i) image="$2"; shift 2; ;;
        --help|-h) usage; exit; ;;
        --tag|-t) tag="$2"; shift 2; ;;
        --copy|-c) copy=1; shift; ;;
        --) shift; break; ;;
        *) break; ;;
    esac
done

folder="/tmp/$RANDOM"
git clone https://github.com/aws-samples/aws-iot-securetunneling-localproxy "$folder"
cd "$folder"
./docker-build.sh
docker tag aws-iot-securetunneling-localproxy "$image:$tag"

if [ $copy -eq 0 ]; then exit; fi

container=$(docker run -d "$image:$tag" sleep infinity)
docker cp "$container":/home/aws-iot-securetunneling-localproxy/localproxy localproxy
docker kill $container