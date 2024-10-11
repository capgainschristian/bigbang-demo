#!/bin/bash

sops -d env > deleteme
source deleteme
rm deleteme

kubectl create namespace bigbang
kubectl create namespace flux-system

kubectl create secret docker-registry private-registry --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_USERNAME} --docker-password=${DOCKER_PASSWORD} -n flux-system

kubectl create secret generic private-git --from-literal=username=${REPO1_USERNAME} --from-literal=password=${REPO1_PASSWORD} -n bigbang

kubectl apply -k https://repo1.dso.mil/platform-one/big-bang/bigbang.git//base/flux?ref=2.22.0

kubectl get deploy -o name -n flux-system | xargs -n1 -t kubectl rollout status -n flux-system

kubectl apply -f dev/bigbang.yaml
