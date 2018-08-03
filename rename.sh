#!/bin/bash

TAR_HOME=$1

if  [ -z "$TAR_HOME" ]; then
  TAR_HOME="tar"
  mkdir -p $TAR_HOME
fi

echo " ===> Image save path is $TAR_HOME"

SOURCE_IMAGES=(dante2012/istio-proxyv2:1.0.0 dante2012/istio-grafana:1.0.0 dante2012/istio-citadel:1.0.0 dante2012/istio-galley:1.0.0 dante2012/istio-mixer:1.0.0 dante2012/istio-servicegraph:1.0.0 dante2012/istio-sidecar_injector:1.0.0)
TAG_IMAGES=(gcr.io/istio-release/proxyv2:1.0.0 gcr.io/istio-release/grafana:1.0.0 gcr.io/istio-release/citadel:1.0.0 gcr.io/istio-release/galley:1.0.0 gcr.io/istio-release/mixer:1.0.0 gcr.io/istio-release/servicegraph:1.0.0 gcr.io/istio-release/sidecar_injector:1.0.0)

echo "Image quantity is ${#SOURCE_IMAGES[@]}"

i=0
while [[ i -lt ${#SOURCE_IMAGES[@]} ]]; do
  image=${SOURCE_IMAGES[i]}
  docker pull $image
  docker tag $image ${TAG_IMAGES[i]}

  tmpImage=${image##*/}
  localImage=$TAR_HOME/${tmpImage/:/-}.tar
  docker save -o $localImage ${TAG_IMAGES[i]}

  docker rmi -f $image
  docker load -i $localImage

  let i++
done

