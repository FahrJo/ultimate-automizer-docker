# Ultimate-Automizer-Docker

Several Dockerfiles and wrappers to use the model checking tool [Ultimate](https://github.com/ultimate-pa/ultimate) inside a Docker container e.g. for use on MacOS.

## UAWrapper

The purpose of the container made from this image is to wrap Ultimate Automizer for use on MacOS. By executing [ultimate_wrapper.sh](ultimate_wrapper.sh) the container is built, the specified setting, toolchain and source files are mapped into the container and Ultimate is executed over the source file. Afterwards the container is destroyed again.

> **Note:** The build process of the image can take some minutes for the first time.

**Example use:**

```bash
#!/bin/bash
./ultimate_wrapper.sh \
    -s ultimate-automizer_settings.epf \
    -tc ultimate-automizer_toolchain.xml \
    -i program.c
```

## UAWebsite

This container hosts the front- and backend of Ultimate.

**Example use:**

```bash
# Build image
docker build -t ultimate-backend .
# Run container and map port
docker run -p 80:80 ultimate-backend 
```

By default, the frontend can be accessed under <http://localhost/website/> and the backend is made
available under <http://localhost/api/>
