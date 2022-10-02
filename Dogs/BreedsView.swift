//
//  ListView.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 30/09/22.
//

import SwiftUI
import MapKit

struct BreedsView: View {
    @State private var phase: AsyncLoadingPhase<Dictionary<String, [String]>> = .pending
    
    var body: some View {
        
        NavigationView {
            switch phase {
            case .success(let breeds):
                List(breeds.sorted(by: {t1,t2 in t1.key > t2.key}), id: \.key) { breed, subBreeds in
                    Section(breed.capitalized) {
                        NavigationLink("See all images") {
                            DogsView(breed: breed)
                                .navigationTitle(breed.capitalized)
                        }
                        ForEach(subBreeds, id: \.self) { subBreed in
                            NavigationLink(subBreed.capitalized) {
                                DogsView(breed: breed, subBreed: subBreed)
                                    .navigationTitle("\(subBreed.capitalized) \(breed.capitalized)")
                            }
                        }
                        
                    }
                }
            case .error(let error):
                Text(error.localizedDescription)
            case .pending:
                ProgressView()
            }
        }
        .refreshable {
            await fetchBreeds()
        }
        .task {
            await fetchBreeds()
        }
    }
    
    private func fetchBreeds() async {
        do {
            phase = .success(try await DogsApi.breeds())
        } catch {
            phase = .error(error)
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsView()
    }
}
