#!/bin/bash

exec > histogram-summary.log 2>&1

HISTOGRAM_URL="https://hg.mozilla.org/mozilla-central/raw-file/tip/toolkit/components/telemetry/Histograms.json"

## Download the latest histogram listing.
rm -f Histograms.json
wget $HISTOGRAM_URL

## Re-render the HTML page.
Rscript --no-save --vanilla -e 'rmarkdown::render("histogram-summary.Rmd")'

## Push new file.
WWW_SERVER_DIR="\"\$WWW/dzeber/tmp\""
HTML_PAGE="histogram-summary.html"
scp $HTML_PAGE dashboard1:~/tmp/
ssh dashboard1 \
    ". .bash_profile;
    cd $WWW_SERVER_DIR;
    mv ~/tmp/$HTML_PAGE .;
    chmod 644 $HTML_PAGE"
[[ $? -ne 0 ]] && echo "Error copying page to web server." || \
echo "HTML page updated."

exit 0
