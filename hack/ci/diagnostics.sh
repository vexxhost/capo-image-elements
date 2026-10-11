#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

# Collect each source independently so a failed query does not hide other evidence.
set -u

kubectl get nodes -o wide
kubectl describe nodes
kubectl get pods -A -o wide
kubectl get events -A --sort-by=.metadata.creationTimestamp
kubectl -n kube-system describe pods
cilium status

while IFS= read -r pod; do
    while IFS= read -r container; do
        echo "::group::${pod}/${container}"
        kubectl -n kube-system logs "$pod" -c "$container" --tail=200
        kubectl -n kube-system logs "$pod" -c "$container" --previous --tail=200
        echo "::endgroup::"
    done < <(kubectl -n kube-system get "$pod" -o jsonpath='{range .spec.initContainers[*]}{.name}{"\n"}{end}{range .spec.containers[*]}{.name}{"\n"}{end}')
done < <(kubectl -n kube-system get pods -o name)

exit 0
