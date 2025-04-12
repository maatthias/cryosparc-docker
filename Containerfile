# FROM nvidia/cuda:12.8.1-devel-rockylinux9
FROM rockylinux:9

# exclude upgrading kernel stuff so we don't break nvidia driver
RUN dnf -y upgrade \
  && dnf install -y epel-release dnf-plugins-core \
  && dnf config-manager --enable crb \
  && dnf install -y \
    zip unzip \
    python3 \
    python3-devel \
    python3-pip \
    libtiff \
    iputils \
    sudo \
    net-tools \
    openssh-server \
    jq \
    munge \
    which \
  && dnf clean all

# # install nvidia driver
# RUN dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/$(uname -i)/cuda-rhel9.repo \
#   && dnf -y install bzip2 automake pciutils elfutils-libelf-devel libglvnd-opengl libglvnd-glx libglvnd-devel acpid dkms \
#   && dnf -y module install nvidia-driver:latest-dkms

# # munge and slurm stuff
# ARG MUNGEUSER=16952
# ARG MUNGEGROUP=1034
# ARG SLURMUSER=16924
# ARG SLURMGROUP=1034
# RUN groupadd -f -g $SLURMGROUP slurm && \
#     useradd -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm -s /bin/bash slurm

# RUN dnf install -y --allowerasing \
#     ca-certificates \
#     gnupg2 && \
#     curl -fsSL https://rpm.nodesource.com/setup_21.x | bash - && \
#     dnf install -y nodejs

# RUN groupmod -o -g $MUNGEGROUP munge && \
#     usermod -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge -s /sbin/nologin munge && \
#     chown -R munge:$MUNGEGROUP /etc/munge

ENV CRYOSPARC_ROOT_DIR=/app
RUN mkdir -p ${CRYOSPARC_ROOT_DIR}
WORKDIR ${CRYOSPARC_ROOT_DIR}

ARG CRYOSPARC_VERSION
ENV CRYOSPARC_VERSION=${CRYOSPARC_VERSION}

ARG CRYOSPARC_LICENSE_ID
ENV CRYOSPARC_LICENSE_ID=${CRYOSPARC_LICENSE_ID}

# install master
ENV CRYOSPARC_MASTER_DIR=${CRYOSPARC_ROOT_DIR}/cryosparc_master

RUN curl -L https://get.cryosparc.com/download/master-latest/${CRYOSPARC_LICENSE_ID} -o cryosparc_master.tar.gz
RUN tar -xzf cryosparc_master.tar.gz
RUN curl -L https://get.cryosparc.com/download/worker-latest/${CRYOSPARC_LICENSE_ID} -o cryosparc_worker.tar.gz
RUN tar -xzf cryosparc_worker.tar.gz

RUN mkdir -p /scratch/cryosparc_cache
RUN useradd -ms /bin/bash cryosparc
# USER cryosparc

# RUN echo -e "[mongodb-org-8.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://pgp.mongodb.com/server-8.0.asc" > /etc/yum.repos.d/mongodb-org-8.0.repo \
#   && dnf -y install mongodb-org

ENV USER=cryosparc
RUN cd ${CRYOSPARC_MASTER_DIR} && \
  ./install.sh --standalone \
    --license $CRYOSPARC_LICENSE_ID \
    --worker_path /${CRYOSPARC_ROOT_DIR}/cryosparc_worker \
    --ssdpath /scratch/cryosparc_cache \
    --initial_email "msnyder@bnl.gov" \
    --initial_password "Password123" \
    --initial_username "msnyder" \
    --initial_firstname "Matt" \
    --initial_lastname "Snyder" \
    --port 39000

# USER root
COPY entrypoint.bash /entrypoint.bash
COPY cryosparc.sh /cryosparc.sh
# ADD slurm /app/slurm

EXPOSE 39000 39001 39002 39003 39004 39006

ENTRYPOINT ["/entrypoint.bash"]
