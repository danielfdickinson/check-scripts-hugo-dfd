#!/bin/bash

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
SITEROOT="."

if [ -d exampleSite ]; then
    SITEROOT=exampleSite
fi

if grep -q baseURL "${SITEROOT}"/config.toml; then
    CROOT="$(grep baseURL exampleSite/config.toml | sed -e 's/^.*[^=]* *'\''\([^'\'']*\)'\'' *$/\1/')"
fi

echo "Using ${CROOT} as canonicalroot"

SKIPS=""; for skip in ${SKIP_CHECK_PATTERNS}; do SKIPS="${SKIPS}${SKIPS:+ }--skip \"${skip}\""; done ; \

URLBASE=public/sitemap.xml

if [ ! -e "$URLBASE" ]; then
    URLBASE=public/index.html
fi

npx hyperlink "$URLBASE" --canonicalroot "${CROOT}" \
    --internal \
    ${SKIPS} \
    --todo "301 http" \
    --todo "fragment-redirect" \
    -r -p "$URLBASE" | tee check-links.log | npx tap-spot
