//
//  JobsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class JobsStore: ObservableObject {
    @Published var jobs: [Job] = Array(repeating: Job.example, count: 10)
}
