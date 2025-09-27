//
//  ReceiverQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverQuestionView: View {
    @State private var isExpandQuesitions:Bool = false
    @State private var isSelectedStar:Bool = true
    var body: some View {
        ZStack{
            Color(red: 0.1, green: 0.1, blue: 0.4)
                .ignoresSafeArea()
            VStack{
                Spacer()
                if isExpandQuesitions{
                    questionList()
                }else{
                    if isSelectedStar{
                        answerButton()
                    }
                    askButton()
                }
            }
        }
        
    }
    
    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            Button{
                //質問を送信
            }label: {
                Text("オリオン座の近くにありますか？")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            Button{
                //質問を送信
            }label: {
                Text("南側にありますか？")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            Button{
                //質問を送信
            }label: {
                Text("どのくらいの明るさですか？")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            Button{
                //質問リストを閉じる
                withAnimation {
                    isExpandQuesitions = false
                }
            }label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black, width: 30))
        }
    }
    @ViewBuilder func askButton() -> some View {
        Button{
            //質問リストを表示
            withAnimation {
                isExpandQuesitions = true
            }
        }label: {
            Text("質問する")
        }
        .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
    }
    @ViewBuilder func answerButton() -> some View {
        Button{
            //正誤判定処理
        }label: {
            Text("ずばり！")
        }
        .buttonStyle(.customThemed(backgroundColor: .yellow, foregroundColor: .black))
    }
}

#Preview {
    ReceiverQuestionView()
}
