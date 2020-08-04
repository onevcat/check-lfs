rm -rf build
xcodebuild -project check-lfs.xcodeproj \
  -scheme check-lfs clean archive -configuration release \
  -sdk macosx -archivePath build/check-lfs.xcarchive
cp build/check-lfs.xcarchive/Products/usr/local/bin/check-lfs build