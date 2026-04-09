#!/bin/bash

# This is a simpler start.sh for minicondor since we don't have secrets or extra config.
prog=${0##*/}

add_values_to () {
    config=$1
    shift
    printf "%s=%s\n" >> "/etc/condor/config.d/$config" "$@"
}

# Bug workaround: daemons will die if they can't raise the number of FD's;
# cap the request if we can't raise it.
hard_max=$(ulimit -Hn)

rm -f /etc/condor/config.d/01-fdfix.conf || true

# Try to raise the hard limit ourselves.  If we can't raise it, lower
# the limits in the condor config to the maximum allowable.
for attr in COLLECTOR_MAX_FILE_DESCRIPTORS \
            SHARED_PORT_MAX_FILE_DESCRIPTORS \
            SCHEDD_MAX_FILE_DESCRIPTORS \
            MAX_FILE_DESCRIPTORS; do
    config_max=$(condor_config_val -evaluate $attr 2>/dev/null)
    if [[ $config_max =~ ^[0-9]+$ && $config_max -gt $hard_max ]]; then
        if ! ulimit -Hn "$config_max" &>/dev/null; then
            add_values_to 01-fdfix.conf "$attr" "$hard_max"
        fi
        ulimit -Hn "$hard_max"
    fi
done
[[ -s /etc/condor/config.d/01-fdfix.conf ]] && \
    echo "# This file was created by $prog" >> /etc/condor/config.d/01-fdfix.conf

# Make munge key for ssh auth
echo "---> Creating munge key"
/sbin/create-munge-key

# Startup sshd for `remote` connections
echo "---> Starting SSHD ..."
# Sometimes on shutdown pid still exists, so delete it
rm -f /var/run/sssd.pid || true
/sbin/sssd --logger=stderr -d 2 -i 2>&1 &

echo "---> Starting the MUNGE Authentication service (munged) ..."
gosu munge /usr/sbin/munged

echo "---> Starting sshd ..."
/usr/sbin/sshd -e

exec /usr/bin/supervisord -c /etc/supervisord.conf

# vim:et:sw=4:sts=4:ts=8
