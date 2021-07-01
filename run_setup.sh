#!/bin/bash
# Copyright (C) 2020 Private Internet Access, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Check if terminal allows output, if yes, define colors for output
if test -t 1; then
  ncolors=$(tput colors)
  if test -n "$ncolors" && test $ncolors -ge 8; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m' # No Color
  else
    GREEN=''
    RED=''
    NC='' # No Color
  fi
fi

# Variables to use for validating input
intCheck='^[0-9]+$'
floatCheck='^[0-9]+([.][0-9]+)?$'

# Only allow script to run as
if [ "$(whoami)" != "root" ]; then
  echo -e "${RED}This script needs to be run as root. Try again with 'sudo $0'${NC}"
  exit 1
fi

# Erase previous authentication token if present
rm -f /opt/piavpn-manual/token /opt/piavpn-manual/latencyList

  export PIA_USER="p4463208"
  export PIA_PASS="moyrk54ScEs8jPX6"

  ./get_token.sh

  tokenLocation="/opt/piavpn-manual/token"
  # If the script failed to generate an authentication token, the script will exit early.
  if [ ! -f "$tokenLocation" ]; then
    exit 1
  else
    PIA_TOKEN=$( awk 'NR == 1' /opt/piavpn-manual/token )
    export PIA_TOKEN
    rm -f /opt/piavpn-manual/token
  fi

export PIA_PF="true"

sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

export AUTOCONNECT="true"
export PREFERRED_REGION=""
export selectServer="no"

export VPN_PROTOCOL="openvpn_udp_standard"

export PIA_DNS="true"

export CONNECTION_READY="true"

./get_region.sh
