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

# TODO fetching as is not fast consider using the base64 diff download  way

# Change-Id: I86d4c27c413250c703ff90d62ecec90ab6b9d358 custom image input
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/53/500953/3 && git cherry-pick FETCH_HEAD

# Change-Id: I09f67d61f00d6997284bcecb2ea8277d56e98084 no tag discovery
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/24/499224/1 && git cherry-pick --strategy-option=ours FETCH_HEAD

# Change-Id: I3684d3a8d5deb93ee25b939a1983c07b74ea7c9a overcloud args
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/87/499287/2 && git cherry-pick FETCH_HEAD

# Change-Id: If5766983b17905158d407c780ce38eb84fdf8860 optional cert
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/67/500067/3 && git cherry-pick FETCH_HEAD

# Change-Id: Ic8babab2b01c8f212bbe02a58a3784cde78d8d52 ansible
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/65/499365/3 && git cherry-pick FETCH_HEAD

# Change-Id: Icc6f7afae0f74e288f0d8418e26fa1a53c7a188f repo
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/93/500093/4 && git cherry-pick FETCH_HEAD

# Change-Id:  Ie644f0b8b7090899ab86b81499c4a9c4a2899c02 virt
RUN git fetch "https://review.gerrithub.io/redhat-openstack/infrared" refs/changes/26/498226/3 && git cherry-pick FETCH_HEAD

RUN pip install -e . && infrared plugin add all && mkdir -p /root/.config/openstack && mkdir /root/.ssh && chmod 600 /root/.ssh


# Branch rhos-infra/cloud-config Change-Id: Ifc3dc443101351d1d84402b768ce2fc28006e02f virt
RUN cd plugins/cloud-config; git fetch "https://review.gerrithub.io/rhos-infra/cloud-config" refs/changes/62/497962/2 && git cherry-pick FETCH_HEAD

RUN pip install -e .

WORKDIR /root
