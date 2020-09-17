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

FROM ir-py:latest
USER root
RUN git clone https://github.com/redhat-openstack/infrared.git && git config --global user.email "you@example.com" && git config --global user.name "Your Name"

WORKDIR infrared
ENV IR_HOME=/root/infrared
# Not mix it with IR_WORKSPACE
ENV IR_WORKSPACES=/root/infrared/.workspaces

# git fetching is not fast, using base64

# Change-Id: I86d4c27c413250c703ff90d62ecec90ab6b9d358 custom container image input
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~500953/revisions/6/patch?download | base64 -d | patch -p1

# Change-Id: I3684d3a8d5deb93ee25b939a1983c07b74ea7c9a overcloud args
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~499287/revisions/2/patch?download | base64 -d | patch -p1

# Change-Id: If5766983b17905158d407c780ce38eb84fdf8860 optional cert
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~500067/revisions/5/patch?download | base64 -d | patch -p1

# Change-Id: Ia1a778c4eca7df063bdc5d6ed7eaf36a9df19ee0 ansible
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~501223/revisions/9/patch?download | base64 -d | patch -p1

# Change-Id: Ia1a778c4eca7df063bdc5d6ed7eaf36a9df19ee0 ansible remove stuff
# https://review.gerrithub.io/c/redhat-openstack/infrared/+/501733
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~501733/revisions/3/patch?download | base64 -d | patch -p1

# Change-Id: Icc6f7afae0f74e288f0d8418e26fa1a53c7a188f repo
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~500093/revisions/5/patch?download | base64 -d | patch -p1

# Change-Id:  Ie644f0b8b7090899ab86b81499c4a9c4a2899c02 virt
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~498226/revisions/3/patch?download | base64 -d | patch -p1

# Change-Id: I803b074ae0e0c7e1a6f30f96ce33463ec43ac25e image upgrade
RUN curl --retry 3 https://review.gerrithub.io/changes/redhat-openstack%2Finfrared~501953/revisions/2/patch?download | base64 -d | patch -p1

RUN pip install -e . && infrared plugin add all && mkdir -p /root/.config/openstack && mkdir /root/.ssh && chmod 600 /root/.ssh


# Branch rhos-infra/cloud-config Change-Id: Ifc3dc443101351d1d84402b768ce2fc28006e02f virt
RUN cd plugins/cloud-config; curl --retry 3 https://review.gerrithub.io/changes/rhos-infra%2Fcloud-config~497962/revisions/2/patch?download | base64 -d | patch -p1

RUN pip install -e .

# tobiko, ocatario, patch-components is intalled automatically
RUN infrared plugin add https://github.com/yobshans/osp-jmeter
RUN infrared plugin add https://git.openstack.org/openstack/tripleo-ha-utils.git
RUN infrared plugin add https://review.gerrithub.io/rhos-infra/build-packages
RUN infrared plugin add https://github.com/rhos-infra/jordan.git
RUN infrared plugin add https://github.com/rhos-infra/tripleo-config-changes
RUN infrared plugin add https://github.com/rhos-infra/bzaf.git
RUN infrared plugin add https://github.com/openstack/ansible-role-collect-logs.git --src-path infrared_plugin && infrared plugin list

# mitogen ?
RUN echo $'\
[defaults]\n\
host_key_checking = False\n\
forks = 500\n\
timeout = 30\n\
force_color = 1\n\
roles_path = infrared/common/roles\n\
library = infrared/common/library\n\
filter_plugins = infrared/common/filter_plugins\n\
callback_plugins = infrared/common/callback_plugins\n\
callback_whitelist = timer,profile_tasks,junit_report\n\
\n\
[ssh_connection]\n\
pipelining = True\n\
control_path = /root/mux-%%h-%%r\n' >/root/infrared/ansible.cfg
