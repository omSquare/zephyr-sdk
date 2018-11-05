FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  --no-install-recommends locales build-essential python3 \
  git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-pip python3-setuptools python3-wheel xz-utils file make gcc \
  gcc-multilib

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

RUN apt-get clean autoclean && apt-get autoremove --yes && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV LANG en_US.UTF-8

COPY gitignore_global /root/.gitignore_global
RUN git config --global core.excludesfile '~/.gitignore_global'

RUN wget -nv https://github.com/zephyrproject-rtos/meta-zephyr-sdk/releases/download/0.9.3/zephyr-sdk-0.9.3-setup.run
RUN sh zephyr-sdk-0.9.3-setup.run

WORKDIR /zephyr

ENV ZEPHYR_TOOLCHAIN_VARIANT zephry
ENV ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk
ENV ZEPHYR_BASE /zephyr

CMD ["/bin/bash"]
