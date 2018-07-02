#!/usr/bin/env bash

cd website/static
bundle exec jekyll build
cd -

./terraform init
./terraform validate website

if [[ $TRAVIS_BRANCH == 'master' ]]
then
    ./terraform workspace select prod
    ./terraform apply -auto-approve website
fi