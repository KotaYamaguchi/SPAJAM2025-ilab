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
        ZStack{
            Color(red: 0.1, green: 0.1, blue: 0.4)
                .ignoresSafeArea()
            //背景にARを使用し，タップでダミー星を配置できるように
            VStack{
                Spacer()
                Text("あなたの星を夜空に隠しましょう")
                    .foregroundStyle(.white)
                    .font(.title3)
                
                Spacer()
                
                Button{
                    currentView = .waitingForQuestion
                }label: {
                    Text("これで決定！")
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black,width: 200))
//                .disabled(true)
//                星を選択している場合のみ押下可能
            }
        }
        
    }
}

#Preview{
    PublisherGameView()
}
