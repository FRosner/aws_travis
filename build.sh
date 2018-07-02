#!/usr/bin/env bash

cd website/static
bundle install
bundle exec jekyll build
cd -

./terraform-linux init
./terraform-linux validate website

if [[ $TRAVIS_BRANCH == 'master' ]]
then
    ./terraform-linux workspace select prod
    ./terraform-linux apply -auto-approve website
fi