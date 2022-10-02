//
//  AsyncLoadingPhase.swift
//  Dogs
//
//  Created by Damiano Pellegrini on 02/10/22.
//

import Foundation


enum AsyncLoadingPhase<T> {
    case success (T)
    case error (Error)
    case pending
}
