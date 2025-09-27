//
//  PublisherQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct PublisherReceiveQuestionView: View {
    var body: some View {
        VStack{
            Text("質問が届きました")
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300,height: 100)
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                Text("オリオン座の近くにありますか？")
            }
            HStack{
                Button{
                    
                }label:{
                    Text("嘘をつく")
                        .padding()
                }
                
                Button{
                    
                }label:{
                    Text("正直に答える")
                    padding()
                }
                
            }
        }
    }
}

#Preview {
    PublisherReceiveQuestionView()
}
