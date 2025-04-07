output_swiftgen="EmbeddedSocial/Sources/Generated/SwiftGen/"
input_storyboards="EmbeddedSocial/Sources"

./EmbeddedSocial/Vendor/swiftgen/bin/swiftgen storyboards -t swift3 --param module="EmbeddedSocial" $input_storyboards -o $output_swiftgen"Storyboards.swift"
