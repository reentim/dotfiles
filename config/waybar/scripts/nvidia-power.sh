#!/usr/bin/bash

power=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | head -n 1)
printf "%.0f W" "$power"
