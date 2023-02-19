//
//  ImageViewerModel.swift
//  WinnipegLife
//
//  Created by changming wang on 6/29/21.
//

import Foundation
import SwiftUI

class ImageViewer: ObservableObject{
    
    @Published var imageIndex:Int = 0 {
        
        didSet{
            imageScale = 1
        }
    }
    
    @Published var showImageViewer:Bool = false
    
    @Published var imageViewerOffset: CGSize = .zero
    
    @Published var bgOpacity: Double = 1
    
    @Published var imageScale: CGFloat = 1
    
    func onChange(value: CGSize){
        
        imageViewerOffset = value
        
        let halgHeight = UIScreen.main.bounds.height / 2
        
        let progress = abs(imageViewerOffset.height / halgHeight)
        
        withAnimation(.default){
            bgOpacity = Double(1 - progress)
        }

    }
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeInOut) {
            let translation = abs(value.translation.height)
            
            if translation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            }
            else{
                showImageViewer.toggle()
                UIScrollView.appearance().bounces = true
                imageViewerOffset = .zero
                bgOpacity = 1
            }
        }
        
    }
    
}
