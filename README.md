# AMD Yocto Toolchain

This is a docker image containig AMD Yocto toolchain.
- The **Dockerfile.Base** installs all necessary packages on a ubuntu image.
- The **Dockerfile.Custom** is used to customise the basic installation without having to re-build the whole Yocot image.
- Use the **yocto-docker** bash script to start the yocto build environment.
