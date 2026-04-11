#!/bin/bash

if ! grep -q 'jotta-cli completion' ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc <<'EOF'

# Source bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Source jotta-cli bash completion
if command -v jotta-cli &>/dev/null; then
    . <(jotta-cli completion bash)
fi
EOF
fi

exec jottad stdoutlog datadir "${DATA_DIR:-/data}"
