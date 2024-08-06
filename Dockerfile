ARG REGISTRY=ccr
FROM ${REGISTRY}/demo/astra:1.8.0-voronezh

######################################
# Сборка AWS SDK S3
# /usr/lib/x86_64-linux-gnu/libaws*.so*
######################################
RUN install_packages \
        git \
        g++ \
        gcc-12 \
        ninja-build \
        cmake \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libssl-dev

RUN git clone --recurse-submodules --depth 1 --branch 1.11.348 https://github.com/aws/aws-sdk-cpp /third_party/aws
RUN cd /third_party/aws && \
    cmake ./ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DTARGET_ARCH=LINUX \
        -DBUILD_ONLY=s3 \
        -DAUTORUN_UNIT_TESTS=OFF \
        -DENABLE_TESTING=OFF \
        -DBUILD_DEPS=ON \
        && \
    cmake --build . && \
    cmake --install . && \
    cd / && rm -r /third_party

######################################
# Сборка cctz для userver
# /usr/local/lib/libcctz.so
######################################
RUN install_packages \
        git \
        g++ \
        gcc-12 \
        ninja-build \
        cmake

RUN git clone --recurse-submodules --depth 1 --branch v2.4 https://github.com/google/cctz /third_party/cctz
RUN cd /third_party/cctz && \
    cmake ./ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_TOOLS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_BENCHMARK=OFF \
        -DBUILD_TESTING=OFF \
        -DBUILD_SHARED_LIBS=ON \
    && \
    cmake --build . && \
    cmake --install . && \
    cd / && rm -r /third_party

######################################
# Сборка amqp-cpp для userver
# /usr/local/lib/libamqpcpp.so*
######################################
RUN install_packages \
        git \
        g++ \
        gcc-12 \
        ninja-build \
        cmake

RUN git clone --recurse-submodules --depth 1 --branch v4.3.26 https://github.com/CopernicaMarketingSoftware/AMQP-CPP /third_party/amqp-cpp
RUN cd /third_party/amqp-cpp && \
    cmake ./ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DAMQP-CPP_BUILD_SHARED=ON \
    && \
    cmake --build . && \
    cmake --install . && \
    cd / && rm -r /third_party

######################################
# Сборка curl для userver
# libcurl versions from 7.88.0 to 8.1.2 may crash on HTTP/2 requests
# /usr/local/lib/libcurl.so*
######################################
RUN install_packages \
    git \
    g++ \
    gcc-12 \
    ninja-build \
    cmake \
    libssl-dev

RUN git clone --recurse-submodules --depth 1 --branch curl-7_86_0 https://github.com/curl/curl /third_party/curl
RUN cd /third_party/curl && \
    cmake ./ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
    && \
    cmake --build . && \
    cmake --install . && \
    cd / && rm -r /third_party

######################################
# Сборка Yandex userver
######################################
RUN install_packages \
        git \
        g++ \
        gcc-12 \
        ninja-build \
        cmake \
        python3-venv \
        python3-jinja2 \
        python3-voluptuous \
        python3-markupsafe \
        python3-yaml \
        libgtest-dev \
        libgmock-dev \
        libboost1.74-dev \
        libboost-program-options1.74-dev \
        libboost-filesystem1.74-dev \
        libboost-regex1.74-dev \
        libboost-stacktrace1.74-dev \
        libboost-locale1.74-dev \
        libboost-iostreams1.74-dev \
        crypto++-dev \
        libcrypto++-dev \
        libyaml-cpp-dev \
        libfmt-dev \
        libc-ares-dev \
        libnghttp2-dev \
        libev-dev \
        libpq-dev \
        libhiredis-dev \
        libzstd-dev \
        libbenchmark-dev \
        libjemalloc-dev

RUN git clone --recurse-submodules --depth 1 --branch v2.1 https://github.com/userver-framework/userver /third_party/userver
RUN cd /third_party/userver && \
    cmake ./ \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DUSERVER_FEATURE_CRYPTOPP_BLAKE2=0 \
        -DUSERVER_FEATURE_CRYPTOPP_BASE64_URL=0 \
        -DUSERVER_USE_LD=gold \
        -DUSERVER_IS_THE_ROOT_PROJECT=OFF \
        -DUSERVER_PIP_USE_SYSTEM_PACKAGES=ON \
        -DUSERVER_FEATURE_UTEST=ON \
        -DUSERVER_FEATURE_TESTSUITE=OFF \
        -DUSERVER_FEATURE_GRPC=OFF \
        -DUSERVER_FEATURE_MONGODB=OFF \
        -DUSERVER_FEATURE_POSTGRESQL=ON \
        -DUSERVER_FEATURE_REDIS=ON \
        -DUSERVER_FEATURE_CLICKHOUSE=OFF \
        -DUSERVER_FEATURE_KAFKA=OFF \
        -DUSERVER_FEATURE_RABBITMQ=ON \
        -DUSERVER_FEATURE_MYSQL=OFF \
        -DUSERVER_FEATURE_ROCKS=OFF \
        -DUSERVER_FEATURE_YDB=OFF \
        -DUSERVER_FEATURE_PATCH_LIBPQ=OFF \
        -DUSERVER_FEATURE_STACKTRACE=OFF \
        -DUSERVER_FEATURE_JEMALLOC=ON \
        -DUSERVER_FEATURE_DWCAS=OFF \
        -DUSERVER_DOWNLOAD_PACKAGES=OFF \
        -DUSERVER_FORCE_DOWNLOAD_PACKAGES=OFF \
        -DUSERVER_INSTALL=ON \
        -DUSERVER_CHECK_PACKAGE_VERSIONS=OFF \
         && \
    cmake --build . && \
    cmake --install . && \
    cd / && rm -r /third_party
