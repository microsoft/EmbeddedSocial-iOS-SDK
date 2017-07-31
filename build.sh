
input_storyboards="EmbeddedSocial/Sources"
input_assets="EmbeddedSocial/Resources/Images.xcassets"
output="EmbeddedSocial/Sources/Generated/SwiftGen/"

swiftgen storyboards -t swift3 --param module="EmbeddedSocial" $input_storyboards -o $output"Storyboards.swift"
swiftgen images -t swift3 $input_assets -o $output"Images.swift"
