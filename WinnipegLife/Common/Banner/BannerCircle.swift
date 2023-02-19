//
//  BannerCircle.swift
//  WinnipegLife
//
//  Created by changming wang on 6/5/21.
//

import Foundation
import SwiftUI


struct BannerCircle: View {
    @Binding var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundColor(self.isSelected ? Color.white : Color.white.opacity(0.5))
    }
}
