//
//  DogsView.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import SwiftUI

struct DogsView: View {
    var breed: String
    var subBreed: String? = nil
    @State private var phase: AsyncLoadingPhase<[String]> = .pending
    
    var body: some View {
        ScrollView {
            switch phase {
            case .success(let images):
                ImagesGrid(columns: (0...1).map { _ in GridItem(.flexible())}, imageURLs: images)
            case .error(let error):
                Text(error.localizedDescription)
            case .pending:
                ProgressView()
            }
        }
        .task {
            await fetchImages()
        }
        .refreshable {
            await fetchImages()
        }
    }
    
    private func fetchImages() async {
        do {
            phase = .success(try await DogsApi.imagesBy(breed: breed,subBreed: subBreed))
        } catch {
            phase = .error(error)
        }
    }
}

struct DogsView_Previews: PreviewProvider {
    static var previews: some View {
        DogsView(breed: "wolfhound")
    }
}
