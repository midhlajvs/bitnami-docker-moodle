#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

for f in $(find /opt/bitnami/moodle -type f -name "*.j2"); do
    echo -e "Evaluating template\n\tSource: $f\n\tDest: ${f%.j2}"
    j2 $f > ${f%.j2}
    rm -f $f
done

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
    . /apache-init.sh
    . /moodle-init.sh
    nami_initialize apache php mysql-client moodle
    info "Starting gosu... "
    . /post-init.sh
fi

exec tini -- "$@"
