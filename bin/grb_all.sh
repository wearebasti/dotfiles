#!/bin/sh
for project in $(find -x /Users/seitzs/Development/ -type d -depth 1); do
    base=$(basename ${project});
    if git -C /Users/seitzs/Development/${base}/ rev-parse --git-dir > /dev/null 2>&1; then
        echo '//////' ${base};
        git -C /Users/seitzs/Development/${base}/ checkout -b himself -q > /dev/null 2>&1;
        git -C /Users/seitzs/Development/${base}/ fetch;
        git -C /Users/seitzs/Development/${base}/ rebase origin/master;
        echo ${base} '//////';
        echo;
    fi
done;
