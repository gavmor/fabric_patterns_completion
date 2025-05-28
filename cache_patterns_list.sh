#!/bin/bash
curl -s https://api.github.com/repos/danielmiessler/fabric/contents/patterns \
  | grep '"name":' \
  | cut -d '"' -f 4 \
  | sort \
  > ~/.cache/fabric_patterns_list.txt
