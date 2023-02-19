//
//  String++.swift
//  WinnipegLife
//
//  Created by changming wang on 7/14/21.
//

import Foundation

extension String {
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    var isValidEmail: Bool {
          let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
          return testEmail.evaluate(with: self)
       }
}
