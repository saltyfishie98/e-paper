#!/bin/bash

# Check if the directory exists
if [ ! -d "/workspaces/e-paper_epd2in4v2/deps" ]; then
    mkdir /workspaces/e-paper_epd2in4v2/deps

    cd /workspaces/e-paper_epd2in4v2/deps \
    && wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.71.tar.gz && tar zxvf bcm2835-1.71.tar.gz \
    && wget https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-1.6.3.tar.gz && tar zxvf libgpiod-1.6.3.tar.gz \
    && git clone https://github.com/WiringPi/WiringPi \
    && rm ./*.tar.gz

    if grep -Fxq "AC_FUNC_MALLOC" "/workspaces/e-paper_epd2in4v2/deps/libgpiod-1.6.3/configure.ac"; then
        sed -i "/AC_FUNC_MALLOC/s/^/# /" "/workspaces/e-paper_epd2in4v2/deps/libgpiod-1.6.3/configure.ac"
    fi

    if grep -Fxq "AC_FUNC_REALLOC" "/workspaces/e-paper_epd2in4v2/deps/libgpiod-1.6.3/configure.ac"; then
        sed -i "/AC_FUNC_REALLOC/s/^/# /" "/workspaces/e-paper_epd2in4v2/deps/libgpiod-1.6.3/configure.ac"
    fi
fi

cd /workspaces/e-paper_epd2in4v2/deps/bcm2835-1.71 \
    && ./configure -host=x86_64 -prefix=$(DEVELROOT) CC=aarch64-linux-gnu-gcc ar=aarch64-linux-gnu-gcc \
    && sudo make \
    && sudo make install

cd /workspaces/e-paper_epd2in4v2/deps/WiringPi \
    && ./build

cd /workspaces/e-paper_epd2in4v2/deps/libgpiod-1.6.3 \
    && ./autogen.sh --enable-tools=yes --host=x86_64 CC=aarch64-linux-gnu-gcc \
    && make \
    && sudo make install