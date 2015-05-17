#!/bin/bash
[ -z "$LOG_DIR" ] && export LOG_DIR=/tmp/zorium_site
[ -z "$LOG_NAME" ] && export LOG_NAME=zorium_site
export NODE_ENV=production

mkdir -p $LOG_DIR

# Replace REPLACE_ENV_* with environment variable
while read -d $'\0' -r file; do
  echo "replacing environment variables in $file" | tee $LOG_DIR/$LOG_NAME.build.log
  while read line; do
    if [[ $line =~ REPLACE_ENV_([A-Z0-9_]+) ]]; then
      env_name="${BASH_REMATCH[1]}"
      env_value=$(eval "echo \$$env_name")
      echo "replacing $env_name with '$env_value'" | tee $LOG_DIR/$LOG_NAME.build.log
      sed -i s/REPLACE_ENV_$env_name/\"$env_value\"/g $file
    fi
  done < <(grep -o "REPLACE_ENV_[A-Z0-9_]\+" $file | uniq)
done < <(find ./dist -iname '*.bundle.js' -print0)

./node_modules/pm2/bin/pm2 \
  start ./bin/server.coffee \
  -i 0 \
  --name $LOG_NAME \
  --merge-logs \
  --no-daemon \
  -o $LOG_DIR/$LOG_NAME.log \
  -e $LOG_DIR/$LOG_NAME.error.log \
  2>&1 | tee $LOG_DIR/$LOG_NAME.pm2.log
