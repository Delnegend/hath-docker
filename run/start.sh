#!/bin/sh

run_application() {
    # set umask accordingly
    if [ "${UMASK:-UNSET}" != "UNSET" ]; then
        umask "$UMASK"
    fi

    # re-create credentials file
    rm -f /hath/data/client_login && echo "Old client_login file removed"
    printf "${HATH_CLIENT_ID}-${HATH_CLIENT_KEY}" >> /hath/data/client_login && echo "New client_login file created"

    exec java -jar /opt/hath/HentaiAtHome.jar \
        --cache-dir=/hath/cache               \
        --data-dir=/hath/data                 \
        --download-dir=/hath/download         \
        --log-dir=/hath/log                   \
        --temp-dir=/hath/tmp                  \
        --disable-ip-origin-check
}

# Run the application and capture its exit code
run_application
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Application failed with exit code $exit_code. Waiting for 5 minutes before retrying..."
  sleep 300
fi

exit $exit_code
