//
//  Backoff.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import Foundation
import SwiftUI

final class BackoffAlgorithm: ObservableObject {
    let maxRetries: Int
    var currentRetry: Int = 0

    init(maxRetries: Int) {
        self.maxRetries = maxRetries
    }



    func reset() {
        self.currentRetry = 0
    }

    func shouldRetry() -> Bool {
        return self.currentRetry <= self.maxRetries
    }
}
