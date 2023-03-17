#!/bin/sh -ve
set -o pipefail

CONFIG=${1:="Debug"}

for TARGET in \
    SkipLib \
    SkipFoundation \
    SkipUI \
    ExampleLib \
    ExampleApp \
    ; do
    # start with a clean DD
    #rm -rf ~/Library/Developer/Xcode/DerivedData

    # make sure the non-Kotlin tests pass on iOS
    xcodebuild test -skipPackagePluginValidation -configuration "${CONFIG}" -sdk "iphonesimulator" -destination "platform=iOS Simulator,name=iPhone 14 Pro" -scheme ${TARGET} | tee xcodebuild-ios-${TARGET}.log

    xcodebuild test -skipPackagePluginValidation -configuration "${CONFIG}" -sdk "macosx" -destination "platform=macosx" -scheme ${TARGET}Kotlin | tee xcodebuild-macos-${TARGET}.log
    # | xcpretty --report junit
    # -only-testing:${TARGET}Tests 

    # get the most recent derived data folder
    DER=`ls -1rtd ~/Library/Developer/Xcode/DerivedData/skip-core-*/SourcePackages/plugins/skip-core.output | tail -n 1`

    tree -lh -I build ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn/

    # run the tests for the target
    # cd ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn
    gradle --project-dir ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn check
done

