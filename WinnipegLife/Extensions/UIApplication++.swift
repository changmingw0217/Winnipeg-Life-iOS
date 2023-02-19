//
//  UIApplication++.swift
//  WinnipegLife
//
//  Created by changming wang on 7/14/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
