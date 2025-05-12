#!/bin/bash
#shellcheck disable=SC2086

if [ -n "$TZ" ] && [ -f "/usr/share/zoneinfo/$TZ" ]; then
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo "$TZ" > /etc/timezone
fi

if [ ! -f "$CONFIG_FILE" ]; then
  cp /app/arrranger_instances.json.example "$CONFIG_FILE"
fi

UV_RUN_CMD="cd /app && uv run main.py"

if [ -n "$CRON_SCHEDULE" ]; then
  echo "Setting up cron job with schedule: $CRON_SCHEDULE"
  echo "${CRON_SCHEDULE} ${UV_RUN_CMD}" | crontab -
  crond -L /var/log/crond.log &
else
  echo "CRON_SCHEDULE is not set. Running script once."
  exec ${UV_RUN_CMD} "$@"
  exit $?
fi

echo "Cron job set up. Container will stay running."
exec tail -f /dev/null