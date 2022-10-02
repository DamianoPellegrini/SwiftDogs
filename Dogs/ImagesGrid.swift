//
//  ImagesGrid.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import SwiftUI

struct ImagesGrid: View {
    var columns: [GridItem]
    var imageURLs: [String]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(imageURLs, id: \.self) { url in
                AsyncImage(url: URL(string: url)!) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else if let _ = phase.error {
                        Label("Error loading: \(url)", systemImage: "exclamationmark.triangle.fill")
                    } else {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    }
                }
            }
        }
    }
}

struct ImagesGrid_Previews: PreviewProvider {
    static var previews: some View {
        ImagesGrid(columns: (0...1).map {_ in GridItem(.flexible())}, imageURLs: [
            "https://images.dog.ceo/breeds/hound-afghan/n02088094_4195.jpg",
            "https://images.dog.ceo/breeds/hound-afghan/n02088094_522.jpg",
            "https://images.dog.ceo/breeds/hound-afghan/n02088094_7131.jpg"
        ])
    }
}
