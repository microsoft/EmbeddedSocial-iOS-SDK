#!/bin/sh

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  fastlane install_pods
  fastlane unit_tests
  exit $?
fi
