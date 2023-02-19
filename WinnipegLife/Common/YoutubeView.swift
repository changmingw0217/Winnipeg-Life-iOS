//
//  YoutubeView.swift
//  WinnipegLife
//
//  Created by changming wang on 6/8/21.
//

import Foundation
import SwiftUI
import youtube_ios_player_helper

struct youtubeView: UIViewRepresentable{
    typealias UIViewType = YTPlayerView
    
    var videoID:String
    
    func makeUIView(context: Self.Context) -> Self.UIViewType{
        let player = YTPlayerView()
        return player
    }
    
    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context){
        uiView.load(withVideoId: videoID,playerVars: ["playsinline": 1])
    }
}
