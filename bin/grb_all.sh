#!/bin/sh

# subdirs="${HOME}/Development/${base}/ ${HOME}/.virtualenvs/${base}/src/${base}/"

for project in $(find -H -x ${HOME}/Development/ -type d -depth 1); do
    base=$(basename ${project});
    if git -C ${HOME}/Development/${base}/ rev-parse --git-dir > /dev/null 2>&1; then
        echo '//////' ${base};
        git -C ${HOME}/Development/${base}/ checkout -b himself -q > /dev/null 2>&1;
        git -C ${HOME}/Development/${base}/ fetch;
        git -C ${HOME}/Development/${base}/ rebase origin/master;
        echo ${base} '//////';
        echo;
    fi
done;

for project in $(find -H -x ${HOME}/.virtualenvs/ -type d -depth 1); do
    base=$(basename ${project});
    if git -C ${HOME}/.virtualenvs/${base}/src/${base}/ rev-parse --git-dir > /dev/null 2>&1; then
        echo '//////' ${base};
        git -C ${HOME}/.virtualenvs/${base}/src/${base}/ checkout -b himself -q > /dev/null 2>&1;
        git -C ${HOME}/.virtualenvs/${base}/src/${base}/ fetch;
        git -C ${HOME}/.virtualenvs/${base}/src/${base}/ rebase origin/master;
        echo ${base} '//////';
        echo;
    fi
done;
