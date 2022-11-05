#!/bin/bash
cd ~/.password-store

PROBLEMS=0
for i in `find . -name "*.gpg" -type f`; do
    gpg --pinentry-mode cancel --list-packets $i 2> /tmp/pass-check-health-error > /dev/null
    if [[ -f /tmp/pass-check-health-error ]]; then
        o=$(cat /tmp/pass-check-health-error)
        if [[ $o == *"gpg: decryption failed: No secret key"* ]]; then
        if [[ $o != *"gpg: public key decryption failed: Operation cancelled"* ]]; then
            printf "No key for $i:\n"
            PROBLEMS=$(( $PROBLEMS + 1 ))
        fi
        fi
    fi
    rm /tmp/pass-check-health-error
done

printf "Found problems: $PROBLEMS\n"
