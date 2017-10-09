xcodebuild \
	-workspace EmbeddedSocial.xcworkspace \
	-scheme EmbeddedSocialTests \
	-destination 'platform=iOS Simulator,name=iPhone 7' \
	test-without-building