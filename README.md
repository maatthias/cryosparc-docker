# build docker image
- first set env var CRYOSPARC_LICENSE_ID={your_license_id}
- [nvidia container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
```sh
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  tee /etc/yum.repos.d/nvidia-container-toolkit.repo
dnf install nvidia-container-toolkit
```
- [CDI for podman support](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html)
```sh
nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
nvidia-ctk cdi list
podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable rockylinux:9 nvidia-smi -L
```
- build image
```sh
podman image build --file Containerfile --tag cryosparc-rockylinux9:latest --build-arg LICENSE_ID={$LICENSE_ID} --network=host --device nvidia.com/gpu=all --security-opt=label=disable .
```
