//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//
import Foundation

extension Photo: JSONEncodable {
    func encodeToJSON() -> Any {
        return self.memento
    }
}
