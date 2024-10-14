#!/bin/bash

sops -d env > deleteme
source deleteme
rm deleteme

kubectl create namespace bigbang
kubectl create namespace flux-system

sops -d base/kms-secret.yaml | kubectl apply -f -

kubectl create secret docker-registry private-registry --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_USERNAME} --docker-password=${DOCKER_PASSWORD} -n flux-system

kubectl create secret generic private-git --from-literal=username=${GITHUB_USERNAME} --from-literal=password=${GITHUB_PASSWORD} -n bigbang

kubectl kustomize flux/ | kubectl apply -f -

kubectl get deploy -o name -n flux-system | xargs -n1 -t kubectl rollout status -n flux-system

kubectl apply -f dev/bigbang.yaml
