#!/bin/bash

SSH_REMOTE="$1"
GDBPORT="$2"

TARGET_USER="saltyfishie-rpi"
TARGET_BIN_FILE="/home/${TARGET_USER}/e-paper/epd"
TARGET_CWD="/home/${TARGET_USER}/e-paper"

echo "${TARGET_USER}@${SSH_REMOTE}:${GDBPORT}"

echo "====== stopping previous gdbserver ======"
ssh "${TARGET_USER}@${SSH_REMOTE}" "killall gdbserver ${TARGET_BIN_FILE}"
echo ""

echo "====== starting sshserver ======"
ssh -f "${TARGET_USER}@${SSH_REMOTE}" "sh -c 'cd ${TARGET_CWD}; nohup gdbserver *:${GDBPORT} ${TARGET_BIN_FILE} &'"

sleep 1.5
echo ""