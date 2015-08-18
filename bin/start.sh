#!/bin/bash
export NODE_ENV=production

# Replace REPLACE_ENV_* with environment variable
while read -d $'\0' -r file; do
  echo "replacing environment variables in $file"
  while read line; do
    if [[ $line =~ REPLACE_ENV_([A-Z0-9_]+) ]]; then
      env_name="${BASH_REMATCH[1]}"
      env_value=$(eval "echo \$$env_name")
      echo "replacing $env_name with '$env_value'"
      sed -i s/REPLACE_ENV_$env_name/\"$env_value\"/g $file
    fi
  done < <(grep -o "REPLACE_ENV_[A-Z0-9_]\+" $file | uniq)
done < <(find ./dist -iname '*.bundle.js' -print0)

./node_modules/coffee-script/bin/coffee ./bin/server.coffee
