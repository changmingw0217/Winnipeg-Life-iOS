//
//  UINacigationController++.swift
//  WinnipegLife
//
//  Created by changming wang on 7/14/21.
//

import Foundation
import SwiftUI


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        return viewControllers.count > 1
    }
}
