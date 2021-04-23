#!/bin/bash
git submodule update --init --recursive && \
ln -s ${PWD}/flux-k8s/flux-plugin/kubeflux pkg/
