#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2154

# Copyright Istio Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# @setup multicluster

set -e
set -u
set -o pipefail

source content/en/docs/setup/install/multicluster/common.sh
set_multi_network_vars

function install_istio_on_cluster1 {
  snip_install_istio_25
  echo y | snip_install_istio_26

  # Expose istiod and services via east-west gateway.
  snip_install_istio_27
  snip_install_istio_28
  snip_install_istio_29
}

function install_istio_on_cluster2 {
  snip_install_istio_30
  snip_install_istio_31
  echo y | snip_install_istio_32

  # Expose services via east-west gateway
  snip_install_istio_33
  snip_install_istio_34
}

# Install Istio on the 2 clusters. Executing in
# parallel to reduce test time.
install_istio_on_cluster1 &
install_istio_on_cluster2 &
wait

# Configure endpoint discovery.
snip_install_istio_35

# Verify that traffic is properly load balanced.
verify_load_balancing

# @cleanup
source content/en/docs/setup/install/multicluster/common.sh
set +e # ignore cleanup errors
set_multi_network_vars
cleanup
