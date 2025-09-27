//
//  ReceiverQuestionView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct ReceiverQuestionView: View {
    @State private var isExpandQuesitions:Bool = false
    var body: some View {
        VStack{
            Spacer()
            if isExpandQuesitions{
                questionList()
            }else{
                askButton()
            }
        }
    }
    
    @ViewBuilder func questionList() -> some View {
        VStack(spacing:10){
            Button{
                
            }label: {
                Text("オリオン座の近くにありますか？")
            }
         
            Button{
                
            }label: {
                Text("オリオン座の近くにありますか？")
            }
          
            Button{
                
            }label: {
                Text("オリオン座の近くにありますか？")
            }
           
            Button{
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
            withAnimation {
                isExpandQuesitions = true
            }
        }label: {
            Text("質問する")
        }
    }
}

#Preview {
    ReceiverQuestionView()
}
