//
//  MachingView.swift
//  SPAJAM2025
//
//  Created by Kota Yamaguchi on 2025/09/27.
//

import SwiftUI

struct MachingView: View {
    var body: some View {
        Text("MachingView")
            .navigationBarTitle("MachingView")
        
        NavigationLink{
        VsView()
        }label: {
            Text("マッチングしました！")
        }
    }
}
