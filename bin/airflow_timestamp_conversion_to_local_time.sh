#!/usr/bin/env zsh


# (loaded on .zshrc source)
function astro_ts_utc_local() {
    # Returns UTC timestamp in Airflow format to local time
    # e.g., 2021-02-13T01:54:59.672021Z ➔ Fri Feb 12 20:54:59 EST 2021
    second_precision_time=$(cut -d'.' -f1 <<< ${1:-$(</dev/stdin)})
    date -j -f "%s" "$(date -j -u -f "%Y-%m-%dT%T" "${second_precision_time}" "+%s")" | tee >(pbcopy)
}
