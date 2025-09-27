//
//  StarHidingView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct StarHidingView: View {
    @Binding var currentView: PublisherViewIdentifier
    var body: some View {
        VStack{
            Spacer()
            Text("あなたの星を")
                .font(.title)
            Text("夜空にまぎれさせましょう")
                .font(.title)
            
            Spacer()
            
            Button{
                currentView = .waitingForQuestion
            }label: {
                Text("これで決定！")
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
