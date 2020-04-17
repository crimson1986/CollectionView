//
//  CollectionView.swift
//  CollectionView
//
//  Created by Chirag Shah on 4/17/20.
//  Copyright © 2020 Chirag Shah. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct CollectionView<Element, Content>: UIViewRepresentable where
                        Element: Hashable, Content: View {

    init(_ diffableDataSource: Binding<NSDiffableDataSourceSnapshot<Int, Element>>,
         minimumLineSpacing: Int = 5,
         minimumInteritemSpacing: Int = 5,
         edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
         content: @escaping (Element) -> Content) {
        self._diffableDataSource = diffableDataSource
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.edgeInsets = edgeInsets
        self.content = content
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UICollectionView {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = edgeInsets
        flowLayout.minimumLineSpacing = CGFloat(minimumLineSpacing)
        flowLayout.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(CollectionViewCell<Content>.self, forCellWithReuseIdentifier: "identifier")
        collectionView.backgroundColor = .clear
        
        let dataSource = UICollectionViewDiffableDataSource<Int, Element>(collectionView: collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! CollectionViewCell<Content>
            
            let content = self.content(object)
            cell.configure(content: content)
            
            return cell
        }

        context.coordinator.dataSource = dataSource

        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        let dataSource = context.coordinator.dataSource
        dataSource?.apply(diffableDataSource, animatingDifferences: true, completion: {
        })
    }

    class Coordinator: NSObject {
        var parent: CollectionView
        var dataSource: UICollectionViewDiffableDataSource<Int, Element>?
        var snapshot = NSDiffableDataSourceSnapshot<Int, Element>()

        init(_ collectionView: CollectionView) {
            self.parent = collectionView
        }
    }
    
    // MARK: Private properties
    
    @Binding private var diffableDataSource: NSDiffableDataSourceSnapshot<Int, Element>

    private var content: (Element) -> Content
    private var minimumLineSpacing: Int = 5
    private var minimumInteritemSpacing: Int = 5
    private var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
}

class CollectionViewCell<Content>: UICollectionViewCell where Content: View  {
    var content: UIHostingController<Content>?
    
    override func prepareForReuse() {
        content?.view.removeFromSuperview()
        content = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        content?.view.frame = bounds
    }
    
    func configure(content: Content) {
        let controller = UIHostingController(rootView: content)
        addSubview(controller.view)
        self.content = controller
    }
}

