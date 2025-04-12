# build cryosparc installation with podman
## install/configure nvidia container toolkit to allow container access to nvidia drivers
### for rhel 9
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
### for rhel 8
- first set env var CRYOSPARC_LICENSE_ID={your_license_id}
- [redhat article on using rhel 8 to do this](https://www.redhat.com/en/blog/how-use-gpus-containers-bare-metal-rhel-8)
```sh
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | tee /etc/yum.repos.d/nvidia-docker.repo
yum -y install nvidia-container-toolkit
wget https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL7/nvidia-container.pp
semodule -i nvidia-container.pp
nvidia-container-cli -k list | restorecon -v -f -
restorecon -Rv /dev
# verify it works
podman run --user 1000:1000 --security-opt=no-new-privileges --cap-drop=ALL \
--security-opt label=type:nvidia_container_t  \
docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1
```
## build image
```sh
podman image build --file Containerfile --tag cryosparc-rockylinux9:latest --build-arg LICENSE_ID={$LICENSE_ID} --network=host --device nvidia.com/gpu=all --security-opt=label=disable .
```
