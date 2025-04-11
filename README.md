# build docker image
- first set env var LICENSE_ID={your_license_id}
- then run the build command:
```sh
podman image build --file Containerfile --tag cryosparc-rockylinux9:latest --build-arg LICENSE_ID={$LICENSE_ID} .
```

