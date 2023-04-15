//
//  JobsViewModel.swift
//  AucaPlus
//
//  Created by Cédric Bahirwe on 15/04/2023.
//

import Foundation

final class JobsViewModel: ObservableObject {
    @Published var jobs: [Job] = []
}

struct Job {
    let id: UUID
    let company: Company
}

struct Company {
    let id: Int
    let name: String
}
