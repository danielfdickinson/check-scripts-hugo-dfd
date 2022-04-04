#!/bin/bash

npx hyperlink public/sitemap.xml --canonicalroot https://www.wildtechgarden.ca/ \
    --internal \
    --skip "https://www.facebook.com/sharer.php" \
    --skip "https://linkedin.com/shareArticle" \
    --skip "https://twitter.com/share" \
    --skip "https://www.pexels.com" \
    --skip "https://pixabay.com" \
    --skip "example.com" \
    --skip "example.net" \
    --todo "301 http" \
    --todo "fragment-redirect" \
    -r -p public/sitemap.xml | tee check-links.log | npx tap-spot
