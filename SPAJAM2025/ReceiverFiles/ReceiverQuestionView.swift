//
//  ReceiverQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverQuestionView: View {
    @State private var isExpandQuesitions:Bool = false
    @State private var isSelectedStar:Bool = false
    var body: some View {
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
    
    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            Button{
                //質問を送信
            }label: {
                Text("オリオン座の近くにありますか？")
            }
            
            Button{
                //質問を送信
            }label: {
                Text("南側にありますか？")
            }
            
            Button{
                //質問を送信
            }label: {
                Text("どのくらいの明るさですか？")
            }
            
            Button{
                //質問リストを閉じる
                withAnimation {
                    isExpandQuesitions = false
                }
            }label: {
                Image(systemName: "xmark")
            }
            
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
    }
    @ViewBuilder func answerButton() -> some View {
        Button{
            //正誤判定処理
        }label: {
            Text("ずばり！")
        }
    }
}

#Preview {
    ReceiverQuestionView()
}
