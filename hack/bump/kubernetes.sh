set -e

# Fetch current maintained Kubernetes versions
VERSIONS=$(curl -s https://endoflife.date/api/v1/products/kubernetes | jq -r '.result.releases[] | select(.isMaintained == true).latest.name' | sort -V)

# Build the version list for YAML
VERSION_LINES=""
for version in $VERSIONS; do
    VERSION_LINES="${VERSION_LINES}          - ${version}\n"
done

# Update CI workflow in place using awk
awk -i inplace -v versions="$VERSION_LINES" '
/^        version:$/ {
    print
    printf "%s", versions
    in_version = 1
    next
}
in_version && /^          -/ {
    # Skip old version lines
    next
}
in_version && !/^          -/ {
    in_version = 0
}
!in_version {
    print
}
' .github/workflows/ci.yaml

# Get the latest stable version (last one in the sorted list)
LATEST_VERSION=$(echo "$VERSIONS" | tail -n 1)

# Update README.md with the latest version
sed -i "s/export DIB_KUBERNETES_VERSION=.*/export DIB_KUBERNETES_VERSION=${LATEST_VERSION}/" README.md

# Update kubeadm with the latest version
sed -i "s/^DIB_KUBEADM_VERSION=.*/DIB_KUBEADM_VERSION=\${DIB_KUBEADM_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/kubeadm/install.d/70-kubeadm

# Update kubectl with the latest version
sed -i "s/^DIB_KUBECTL_VERSION=.*/DIB_KUBECTL_VERSION=\${DIB_KUBECTL_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/kubectl/install.d/70-kubectl

# Update kubelet with the latest version
sed -i "s/^DIB_KUBELET_VERSION=.*/DIB_KUBELET_VERSION=\${DIB_KUBELET_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/kubelet/install.d/70-kubelet

# Update environment with the latest version
sed -i "s/^export DIB_KUBERNETES_VERSION=.*/export DIB_KUBERNETES_VERSION=\${DIB_KUBERNETES_VERSION:-\"${LATEST_VERSION}\"}/" \
  elements/kubernetes/environment.d/10-kubernetes

echo "Updated Kubernetes versions in CI workflow to:"
echo "$VERSIONS"
echo ""
echo "Updated README.md DIB_KUBERNETES_VERSION to: ${LATEST_VERSION}"
echo "Updated Kubernetes components to version ${LATEST_VERSION}."
