# build docker image
- first set env var LICENSE_ID={your_license_id}
- then run the build command:
```sh
docker image build --file Dockerfile --tag cryosparc-rockylinux9:latest --build-arg LICENSE_ID={$LICENSE_ID} .
```

