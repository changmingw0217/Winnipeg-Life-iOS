//
//  View++.swift
//  WinnipegLife
//
//  Created by changming wang on 7/14/21.
//

import Foundation
import SwiftUI

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    func getRecct()->CGRect{
        
        return UIScreen.main.bounds
    }
}
