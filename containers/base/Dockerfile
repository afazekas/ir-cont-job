# Copyright (C) 2020 Red Hat
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

FROM centos:8
USER root

# Our prefered lsb mta is postfix (not exim)
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf update -y && \
    dnf install -y \
      postfix \
      make \
      sudo \
      bzip2 \
      cmake \
      gcc \
      gcc-c++ \
      git \
      make \
      python3 \
      libpq-devel \
      mariadb-devel \
      libxslt-devel \
      openssl-devel \
      rsync \
      unzip \
      strace \
      vim-enhanced \
      gdb \
      redhat-lsb-core

# lsb distro MUST have /usr/bin/python
RUN update-alternatives --set python /usr/bin/python3

# el8 does not manges pip link
RUN ln -s /bin/pip3 /bin/pip

# Enable root local bin
ENV PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /root
