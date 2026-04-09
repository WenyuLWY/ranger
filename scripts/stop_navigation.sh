#!/bin/bash
set -e

echo "===================================="
echo "🛑 Stopping navigation nodes..."
echo "===================================="

NODES=(
  "move_base"
  "map_server"
  "cartographer_node"
)

if ! pgrep -x "roscore" >/dev/null; then
  echo "⚠️  roscore not running — nothing to stop."
  exit 0
fi

for node in "${NODES[@]}"; do
  PIDS=$(ps aux | grep "$node" | grep -v grep | awk '{print $2}')
  if [ -n "$PIDS" ]; then
    echo "🔹 Stopping $node (PIDs: $PIDS)"
    kill -2 $PIDS 2>/dev/null || true
    sleep 1
  else
    echo "✅ $node not running"
  fi
done

LEFT=$(ps aux | grep -E "move_base|cartographer|map_server|amcl" | grep -v grep || true)
if [ -n "$LEFT" ]; then
  echo "⚠️  Some nodes still running, forcing termination..."
  echo "$LEFT" | awk '{print $2}' | xargs kill -9 2>/dev/null || true
fi

echo "✅ Navigation stack stopped successfully."
exit 0
