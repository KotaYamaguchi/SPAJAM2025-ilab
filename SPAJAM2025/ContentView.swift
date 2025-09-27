//
//  ContentView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loader = StarLoader()
    @StateObject private var gameCenterManager = GameCenterManager()
    
    var body: some View {
//        NavigationStack{
//            TitleView()
//        }
        VStack{
            MatchStartView()
                .environmentObject(gameCenterManager)
        }
    }
}

#Preview {
    ContentView()
}
