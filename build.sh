#! /bin/bash

randstr=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
project=mirnetv2
containerid=$project-build-$randstr
imageid=$project-build-$(id -u)

(set -xe; docker build --progress=plain -t $imageid .)

set -xe

docker run -it --rm --gpus all \
    --name $containerid \
    -v "$PWD/ckpt:/MIRNetv2/Real_Denoising/pretrained_models" \
    -v "$PWD/ckpt:/MIRNetv2/Enhancement/pretrained_models" \
    -v "$PWD/ckpt:/MIRNetv2/Super_Resolution/pretrained_models" \
    -v "$PWD/output:/MIRNetv2/output" \
    -v "$PWD/input:/MIRNetv2/input" \
    $imageid

#current_script=$( dirname "$(readlink -f "$0")" )
#podman cp $containerid:/dist $current_script
#podman rm $containerid

#(set -xe; podman build --target docker -t $project .)

#podman run -it --rm \
#    --name $project-$randstr \
#    $project
