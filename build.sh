
echo "---=== Swift gen ===---"

input_storyboards="EmbeddedSocial/Sources"
input_assets="EmbeddedSocial/Resources/Images.xcassets"
output_swiftgen="EmbeddedSocial/Sources/Generated/SwiftGen/"

swiftgen storyboards -t swift3 --param module="EmbeddedSocial" $input_storyboards -o $output_swiftgen"Storyboards.swift"
swiftgen images -t swift3 $input_assets -o $output_swiftgen"Images.swift"

echo "---=== Sourcery ===---"

input_sourcery="EmbeddedSocial/Sources/Model/Entities/"
output_sourcery="EmbeddedSocial/Sources/Generated/Sourcery/"

sourcery --sources $input_sourcery --templates ./templates --output $output_sourcery
