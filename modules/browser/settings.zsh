# Prints the settings fragment for BROWSER_EXTRA: pre-approves each chrome-<id> command.
source ${0:A:h:h:h}/lib/env.sh
allow=()
for b in ${(z)BROWSER_EXTRA}; do allow+="Bash(chrome-${b%%:*}:*)"; done
jq -n '{permissions: {allow: $ARGS.positional}}' --args $allow
