# Instance Configuration
export CRYOSPARC_LICENSE_ID="{5598bde0-13b9-11f0-af32-ef181c1290ef}"
export CRYOSPARC_MASTER_HOSTNAME="267b701e456e"
export CRYOSPARC_DB_PATH="/app/cryosparc_database"
export CRYOSPARC_BASE_PORT=39000
export CRYOSPARC_DB_CONNECTION_TIMEOUT_MS=20000

# Security
export CRYOSPARC_INSECURE=false
export CRYOSPARC_DB_ENABLE_AUTH=true

# Cluster Integration
export CRYOSPARC_CLUSTER_JOB_MONITOR_INTERVAL=10
export CRYOSPARC_CLUSTER_JOB_MONITOR_MAX_RETRIES=1000000

# Project Configuration
export CRYOSPARC_PROJECT_DIR_PREFIX='CS-'

# Development
export CRYOSPARC_DEVELOP=false

# Other
export CRYOSPARC_CLICK_WRAP=true

# force container to use the hostname of the container
# export CRYOSPARC_FORCE_HOSTNAME=true
# export CRYOSPARC_HOSTNAME_CHECK=cryosparc