#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# Prepare config file and fix port
cp config/config.dist.js config/config.js
sed -i 's/8080/80/' config/config.js

# Increase refresh rate from 3 seconds to 0.5 seconds
sed -i 's/setTimeout(poll_results, 3000)/setTimeout(poll_results, 500)/' js/tool_interface.js