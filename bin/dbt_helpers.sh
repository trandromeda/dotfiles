#!/usr/bin/env sh


## DBT custom functions

# Cycle DBT logs
function cycle_logs() {
  suffix=$(date '+%Y-%m-%dT%H:%M:%S')
  mv -v logs/dbt.log logs/dbt.log.${suffix}
}

# Run and test one model and/or its up-/down- stream dependencies
function dbt_run_test() {
    models=$1
    echo "Running & testing: ${models}"
    dbt run --models ${models} | tee && dbt test --models ${models} | tee >(pbcopy);
}

# Build downstream dependencies for all models changes in working directory
# Takes optional argument, +, to build downstream dependencies
function dbt_run_changed() {
    children=$1
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        models="$(git diff --name-only | grep '\.sql$' | awk -F '/' '{ print $NF }' | sed "s/\.sql$/${children}/g" | tr '\n' ' ')"
        echo "Running models: ${models}"
        dbt run --models ${models};
    else
        git rev-parse --git-dir > /dev/null 2>&1;
    fi;
}
