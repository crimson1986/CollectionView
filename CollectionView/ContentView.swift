//
//  ContentView.swift
//  CollectionView
//
//  Created by Chirag Shah on 4/17/20.
//  Copyright © 2020 Chirag Shah. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataSource = DataSourceProvider()

    var body: some View {
        VStack {
            CollectionView($dataSource.diffableDataSource) {_ in
                Text("Hello")
            }.background(Color.red)
            
            Button("Add") {
                self.dataSource.addItems(items: [DataModel(title: "Hello"), DataModel(title: "World")], to: 0)
            }

            Button("Remove all") {
                self.dataSource.diffableDataSource.deleteSections([0])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
