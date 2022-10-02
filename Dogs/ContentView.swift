//
//  ContentView.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 30/09/22.
//

import SwiftUI

struct ContentView: View {
    @State private var breed: String? = nil
    @State private var subBreed: String? = nil
//    @State private var isShowingDialog = false
//
//    private var isFiltered: Bool {
//        get { return breed != nil }
//    }
    
    var body: some View {
        TabView {
            GPSView().tabItem {
                Label("GPS", systemImage: "location")
            }
//            VStack {
//                HStack {
//                    if isFiltered {
//                        Button("Clear filters") {
//                            subBreed = nil
//                            breed = nil
//                        }.padding(0)
//                    }
//                    Spacer()
//                    Button {
//                        breed = "hound"
//                    } label: {
//                        Image(systemName: isFiltered ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
//                    }
//                }.padding()
                RandomView(breed: breed, subBreed: subBreed)
//            }
            .tabItem { Label("Random", systemImage: "questionmark") }
                BreedsView()
                    .tabItem { Label("List", systemImage: "list.triangle") }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
