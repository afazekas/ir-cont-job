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
RUN git clone https://github.com/redhat-openstack/infrared.git
WORKDIR infrared
RUN pip install -e . && infrared plugin add all && mkdir -p /root/.config/openstack && mkdir /root/.ssh && chmod 600 /root/.ssh
WORKDIR /root
