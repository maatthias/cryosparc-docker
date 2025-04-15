#! /bin/bash

# cd ${CRYOSPARC_MASTER_DIR} && \
#   ./install.sh --standalone \
#     --license $CRYOSPARC_LICENSE_ID \
#     --worker_path /${CRYOSPARC_ROOT_DIR}/cryosparc_worker \
#     --ssdpath /scratch/cryosparc_cache \
#     --initial_email "msnyder@bnl.gov" \
#     --initial_password "Password123" \
#     --initial_username "msnyder" \
#     --initial_firstname "Matt" \
#     --initial_lastname "Snyder" \
#     --port 39000

cryosparcm configuredb
cryosparcm start