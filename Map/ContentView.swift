//
//  ContentView.swift
//  Map
//
//  Created by 渡辺大智 on 2023/12/31.
//

import SwiftUI

struct ContentView: View {
    
    @State var inputText: String = ""
    @State var displaySearchKey: String = "東京駅"
    @State var displayMapType: MapType = .standard
    
    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                //このモディファイアでinputTextが変更完了されたことがわかる(改行が押されたことがわかる)
                .onSubmit {
                    //ここでdisplaySearchKeyが変化してMapView再描画をトリガーする
                    displaySearchKey = inputText
                }
                .padding()
            
            ZStack(alignment: .bottomTrailing) {
                MapView(searchKey: displaySearchKey, mapType: displayMapType)
                
                Button {
                    if displayMapType == .standard {
                        displayMapType = .satellite
                    } else if displayMapType == .satellite {
                        displayMapType = .hybrid
                    } else if displayMapType == .hybrid {
                        displayMapType = .standard
                    }
                } label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                }
                .padding(.trailing, 20.0)
                .padding(.bottom, 30.0)
            }
        }
    }
}

#Preview {
    ContentView()
}
