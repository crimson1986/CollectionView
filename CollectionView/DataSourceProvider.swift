//
//  DataSourceProvider.swift
//  CollectionView
//
//  Created by Chirag Shah on 4/17/20.
//  Copyright © 2020 Chirag Shah. All rights reserved.
//

import Foundation
import UIKit

struct DataModel: Hashable {
    let id = UUID()
    let title: String
}

final class DataSourceProvider: ObservableObject {
    
    @Published var diffableDataSource : NSDiffableDataSourceSnapshot<Int, DataModel> = {
        var snap = NSDiffableDataSourceSnapshot<Int, DataModel>()
        snap.appendSections([0])
        return snap
        }()

    func addItems(items: [DataModel], to section: Int) {
        if diffableDataSource.sectionIdentifiers.contains(section) {
            diffableDataSource.appendItems(items, toSection: section)
        } else {
            diffableDataSource.appendSections([section])
            diffableDataSource.appendItems(items, toSection: section)
        }
    }
}
