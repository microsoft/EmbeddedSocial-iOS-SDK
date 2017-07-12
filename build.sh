
input_storyboards="MSGP/Sources"
input_assets="MSGP/Resources/Images.xcassets"
output="MSGP/Sources/Generated/SwiftGen/"

swiftgen storyboards -t swift3 --param module="MSGP" $input_storyboards -o $output"Storyboards.swift"
swiftgen images -t swift3 $input_assets -o $output"Images.swift"
