//
//  ReceiverQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverQuestionView: View {
    @State private var isExpandQuesitions:Bool = false
    @State private var isSelectedStar:Bool = false
    
    // 表示するランダムな質問を保持するState変数
    @State private var displayedQuestions: [String] = []
    
    // 質問の全体リスト
    // 質問は、毎回ランダムに3つ選ばれるため、元のダミーボタンを置き換えるためにquestionsから取得します。
    let questions: [String] = [
        "空の真上に近い位置に見えますか？",
        "北の空に見えますか？",
        "東の空に見えますか？",
        "オリオン座の近くにありますか？",
        "北斗七星の近くにありますか？",
        "天の川の近くにありますか？",
        "太陽系の惑星の近くにありますか？",
        "地平線から30度以下の低い位置に見えますか？",
        "目で見える最も明るい星と近いですか？",
        "近くに，赤やオレンジ色に見える星がありますか？",
        "金星や木星と近くにありますか？",
    ]

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
    
    // 質問リストを表示する際に、ランダムに3つの質問を選び出す関数
    private func selectRandomQuestions() {
        // questionsからランダムに3つの質問を選び、State変数に格納
        // shuffle()で質問をシャッフルし、prefix(3)で先頭の3つを取得
        displayedQuestions = questions.shuffled().prefix(3).map { $0 }
    }
    
    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            
            // 選択された3つの質問をループしてボタンを生成
            ForEach(displayedQuestions, id: \.self) { question in
                Button {
                    // 質問を送信する処理
                    // ここに質問を送信するロジックを実装します
                    print("質問を送信: \(question)")

                    // 質問を送信したら、質問リストを閉じる（任意）
                    withAnimation {
                        isExpandQuesitions = false
                    }
                } label: {
                    Text(question)
                }
                .buttonStyle(.customThemed(backgroundColor: .white, foregroundColor: .black))
            }
            
            // 閉じるボタン
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
            // 質問リストを表示する前に、ランダムな質問をセット
            selectRandomQuestions()
            
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
            Text("ZUBARI！")
        }
        .buttonStyle(.customThemed(backgroundColor: .yellow, foregroundColor: .black))
    }
}

#Preview {
    ReceiverQuestionView()
}
