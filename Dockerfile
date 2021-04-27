FROM registry.access.redhat.com/ubi8:latest as base

ENV CNB_USER_ID=1001
ENV CNB_GROUP_ID=1001
ENV CNB_STACK_ID="io.buildpacks.sclorg.ubi8-stack"
LABEL io.buildpacks.stack.id="io.buildpacks.sclorg.ubi8-stack"

# S2I specific variables
ENV APP_ROOT=/opt/app-root
ENV PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH

RUN groupadd cnb --gid ${CNB_GROUP_ID} && \
    useradd --uid ${CNB_USER_ID} --gid ${CNB_GROUP_ID} -m -s /bin/bash cnb

FROM base as run

# Install packages that we want to make available at run time
RUN INSTALL_PKGS="glibc-langpack-en \
    glibc-locale-source \
    groff-base \
    httpd \
    libtool-ltdl \
    mod_auth_gssapi \
    mod_ldap \
    mod_session \
    mod_ssl \
    nss_wrapper \
    procps-ng \
    python36 \
    ruby \
    rubygem-bundler" && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all --enablerepo='*'

USER ${CNB_USER_ID}:${CNB_GROUP_ID}

FROM base as build

# Install packages that we want to make available at build time
RUN INSTALL_PKGS="atlas-devel \
    autoconf \
    automake \
    bsdtar \
    bzip2 \
    enchant \
    findutils \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    gd-devel \
    gdb \
    gettext \
    git \
    httpd-devel \
    libcurl-devel \
    libffi-devel \
    libpq-devel \
    libxml2-devel \
    libxslt-devel \
    lsof \
    make \
    mariadb-connector-c-devel \
    npm \
    openssl-devel \
    patch \
    python36-devel \
    python3-pip \
    python3-setuptools \
    python3-virtualenv \
    python36-devel \
    redhat-rpm-config \
    rsync \
    ruby-devel \
    rubygem-bundler \
    rubygem-rake \
    scl-utils \
    sqlite-devel \
    tar \
    unzip \
    wget \
    which \
    xz \
    yum \
    zlib-devel" && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all --enablerepo='*'

USER ${CNB_USER_ID}:${CNB_GROUP_ID}
