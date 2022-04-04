#!/bin/bash

set -o pipefail

SITEROOT="."

if [ -d exampleSite ]; then
    SITEROOT=exampleSite
fi

if npx html-validate "${SITEROOT}"/public 2>&1 | tee html-validate.log; then
    echo "ok"
else
    echo "not ok"
fi
