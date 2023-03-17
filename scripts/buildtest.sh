#!/bin/sh -ve
set -o pipefail

for TARGET in \
    SkipLib \
    SkipFoundation \
    SkipUI \
    ExampleLib \
    ExampleApp \
    ; do
    # start with a clean DD
    #rm -rf ~/Library/Developer/Xcode/DerivedData

    xcodebuild test -skipPackagePluginValidation -configuration Debug -sdk "macosx" -destination "platform=macosx" -scheme ${TARGET}Kotlin | tee xcodebuild.log | xcpretty --report junit

    tree ~/Library/Developer/Xcode/DerivedData

    date

    # get the most recent derived data folder
    DER=`ls -1rtd ~/Library/Developer/Xcode/DerivedData/skip-core-*/SourcePackages/plugins/skip-core.output | tail -n 1`

    # -only-testing:${TARGET}Tests 
    tree -lh -I build ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn/

    # run the tests for the target
    # cd ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn
    gradle --project-dir ${DER}/${TARGET}KotlinTests/SkipTranspilePlugIn test
done

