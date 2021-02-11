#!/bin/bash
quasar build
rm ~/git/perso/ytd/www/*
rm -rf ~/git/perso/ytd/www/*
cp -r ./dist/spa/* ~/git/perso/ytd/www/
pushd ~/git/perso/ytd/
ANDROID_SDK_ROOT=/opt/Android/Sdk
PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:/home/paul/.gradle/wrapper/dists/gradle-5.6.4-all/ankdp27end7byghfw1q2sw75f/gradle-5.6.4/bin/
phonegap build android
cordova run android
popd
