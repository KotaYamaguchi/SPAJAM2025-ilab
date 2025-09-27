//
//  ReceiverQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverQuestionView: View {
    var body: some View {
        VStack{
            Text("質問が届きました")
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300,height: 100)
                    .foregroundStyle(.white)
                Text("オリオン座の近くにありますか？")
            }
            HStack{
                Button(action: {
                    //はいを押したときの処理
                }){
                    Text("嘘をつく")
                        .frame(width: 100,height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    //いいえを押したときの処理
                }){
                    Text("正直に答える")
                        .frame(width: 120,height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    ReceiverQuestionView()
}
