//
//  MachingView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI
//マッチングの一連の流れをこのViewに記入します．
struct MachingView: View {
    var body: some View {
        Text("MachingView")
            .navigationBarTitle("MachingView")
        
        NavigationLink{
        VSView()
        }label: {
            Text("マッチングしました！")
        }
    }
}
