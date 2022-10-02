//
//  RandomView.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 30/09/22.
//

import SwiftUI

struct RandomView: View {
    var breed: String? = nil
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
            await fetchRandomImages()
        }
        .refreshable {
            await fetchRandomImages()
        }
    }
    
    private func fetchRandomImages() async {
        do {
            let msg = try await DogsApi.randomImages(by: breed, specifically: subBreed, count: 20)
            
            if case let .array(subBreeds) = msg {
                phase = .success(subBreeds.filter({ item in URL(string: item) != nil }))
            } else {
                phase = .error(DogError.invalidMessage)
            }
        } catch {
            phase = .error(error)
        }
    }
}

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        RandomView()
    }
}
