#! /bin/bash

# # cryosparc installation needs non-root user
# export USER=cryosparc
# # however allow any user to start service
# export CRYOSPARC_FORCE_USER=true

# cd ${CRYOSPARC_MASTER_DIR} && \
#   ./install.sh --standalone \
#     --license $CRYOSPARC_LICENSE_ID \
#     --worker_path /${CRYOSPARC_ROOT_DIR}/cryosparc_worker \
#     --ssdpath /scratch/cryosparc_cache \
#     --initial_email "cryosparc@bnl.gov" \
#     --initial_password "Password123" \
#     --initial_username "cryosparc" \
#     --initial_firstname "Cryo" \
#     --initial_lastname "Sparc" \
#     --port 39000


# cryosparcm configuredb
cryosparcm start