#!/bin/bash

VERSION=${1:-6.1.1} # Default value 6.1.1
BUILD_DIRECTORY="Build"

function convert_frameworks_arm64_to_iphonesimulator() {
  project_name=$1
  framework_name=$2

  xcrun vtool -arch arm64 \
    -set-build-version 7 12.0 15.2 \
    -replace \
    -output "../Carthage/Build/iOS/$framework_name.framework/$framework_name" \
    "../Carthage/Build/iOS/$framework_name.framework/$framework_name"
}

function archive_project_iphoneos() {
  project_name=$1
  framework_name=$2

  # Archive iOS project.
  xcodebuild archive\
   -project "../$project_name.xcodeproj"\
   -scheme "$framework_name"\
   -configuration "Release"\
   -destination "generic/platform=iOS"\
   -archivePath "$framework_name.framework-iphoneos.xcarchive"\
   SKIP_INSTALL=NO\
   BUILD_LIBRARY_FOR_DISTRIBUTION=YES
}

function archive_project_iphonesimulator() {
  project_name=$1
  framework_name=$2

  # Archive iOS Simulator project.
  xcodebuild archive\
     -project "../$project_name.xcodeproj"\
     -scheme "$framework_name"\
     -configuration "Simulator Release"\
     -destination "generic/platform=iOS Simulator"\
     -archivePath "$framework_name.framework-iphonesimulator.xcarchive"\
     SKIP_INSTALL=NO\
     BUILD_LIBRARY_FOR_DISTRIBUTION=YES
}

function create_xcframework() {
  project_name=$1
  framework_name=$2

  # Create XCFramework from the archived project.
  xcodebuild -create-xcframework\
    -framework "$framework_name.framework-iphoneos.xcarchive/Products/Library/Frameworks/$framework_name.framework"\
    -framework "$framework_name.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/$framework_name.framework"\
    -output "$framework_name.xcframework"

    # Compress the XCFramework.
    zip -r -X "$framework_name.xcframework.zip" "$framework_name.xcframework/"

    # Save the SHA-256 checksum
    shasum -a 256 "$framework_name.xcframework.zip" >> checksum.txt

    # Save the SHA-256 checksum and skip the filename
    checksum=$(eval shasum -a 256 "$framework_name.xcframework.zip" | sed -r 's:\\*([^ ]*).*:\1:')
    replace_sed "__${framework_name}__checksum__" $checksum "../Package.swift"
}

function replace_sed() {
  old_string=$1
  new_string=$2
  file_name=$3

  sed -i -e "s#${old_string}#${new_string}#g" "${file_name}"
  rm -rf "$file_name-e"
}

function cleanup() {
  # rm -r *.xcframework
  rm -r *.xcarchive
}

# Install Google Maps SDK for iOS.
carthage update

rm -rf $BUILD_DIRECTORY
mkdir $BUILD_DIRECTORY
cd $BUILD_DIRECTORY

cp -R "../Templates/Package.swift.template" "../Package.swift"
echo "Version: $VERSION" >> checksum.txt

frameworks=("GoogleMaps" "GoogleMapsBase" "GoogleMapsCore" "GoogleMapsM4B" "GooglePlaces")
for framework in "${frameworks[@]}"; do
  archive_project_iphoneos "GoogleMaps" "$framework"
done
for framework in "${frameworks[@]}"; do
  convert_frameworks_arm64_to_iphonesimulator "GoogleMaps" "$framework"
done
for framework in "${frameworks[@]}"; do
  archive_project_iphonesimulator "GoogleMaps" "$framework"
done
for framework in "${frameworks[@]}"; do
  create_xcframework "GoogleMaps" "$framework"
done

replace_sed "__VERSION__" $VERSION "../Package.swift"

cleanup

git add "../Package.swift"
git commit -m "Bump version $VERSION"
git tag $VERSION

echo $'\n** XCFRAMEWORK CREATION FINISHED **\n'