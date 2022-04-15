#!/bin/bash

if [ -z "$SKIP_CHECK_PATTERNS" ]; then
    SKIP_CHECK_PATTERNS="https://www.facebook.com/sharer.php \
https://www.linkedin.com/shareArticle  \
https://linkedin.com/shareArticle \
https://twitter.com/share \
https://www.pexels.com \
https://pixabay.com \
http://doi.org/ \
https://doi.org/ \
https://www.nature.com/ \
https://arxiv.org/ \
https://www.facebook.com/ \
https://facebook.com/ \
https://business.facebook.com \
example.com \
example.net"
fi

CROOT="${1:-https://www.example.com}"
SITEROOT="$(pwd)"

if [ -d exampleSite ]; then
    SITESRC=exampleSite
fi

if grep -q baseURL "${SITEROOT}"/config.toml; then
    CROOT="$(grep baseURL exampleSite/config.toml | sed -e 's/^[^=]*= *\('\''\|"\)\([^'\''"]*\)\('\''\|"\)\( \|\n\)*$/\2/')"
fi

echo "Using ${CROOT} as canonicalroot"

SKIPS=""
# shellcheck disable=SC2089
for skip in ${SKIP_CHECK_PATTERNS}; do SKIPS="${SKIPS}${SKIPS:+ }--skip \"${skip}\""; done

URLBASE="${SITEROOT}"/public/sitemap.xml

if [ ! -e "$URLBASE" ]; then
    URLBASE="${SITEROOT}"/public/index.html
fi

# shellcheck disable=SC2090,SC2086
npx hyperlink "$URLBASE" --canonicalroot "${CROOT}" \
    ${SKIPS} \
    --todo "301 http" \
    --todo "fragment-redirect" \
    -r -p "$URLBASE" | tee check-links.log | npx tap-spot
