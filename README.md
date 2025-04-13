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
#### host preparation
- To do this in rhel8 is a bit more laborious than rhel 9 since there is no toolkit support (we have to use the runtime)
- first set env var CRYOSPARC_LICENSE_ID={your_license_id}
- rhel8 requires container runtime hook
- [redhat article on using rhel 8 to do this with container runtime hook](https://www.redhat.com/en/blog/how-use-gpus-containers-bare-metal-rhel-8) but the basic steps distilled below
```sh
# check there are no nouveau drivers
lsmod | grep -i nouveau
# and remove if so
modprobe -r nouveau

# get and install cuda drivers
yum -y install http://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-repo-rhel8-10.2.89-1.x86_64.rpm
yum -y install cuda

# official nvidia cuda toolkit instructions
wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-rhel8-12-8-local-12.8.1_570.124.06-1.x86_64.rpm
rpm -i cuda-repo-rhel8-12-8-local-12.8.1_570.124.06-1.x86_64.rpm
dnf clean all
dnf -y install cuda-toolkit-12-8
# nvidia driver instructions (open flavor)
dnf -y module install nvidia-driver:open-dkms

# Load the NVIDIA and the unified memory kernel modules.
nvidia-modprobe && nvidia-modprobe -u

# verify with
nvidia-smi --query-gpu=gpu_name --format=csv,noheader --id=0
podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable rockylinux:9 nvidia-smi -
```

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | tee /etc/yum.repos.d/nvidia-docker.repo

## build image

```sh
podman image build --device nvidia.com/gpu=all --security-opt=label=disable --file Containerfile --tag cryosparc-rockylinux9:latest --build-arg CRYOSPARC_LICENSE_ID={$CRYOSPARC_LICENSE_ID} --network=host
```
