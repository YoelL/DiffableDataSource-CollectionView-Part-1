//
//  ViewController.swift
//  DiffableDataSource CollectionView
//
//  Created by Yoel Lev on 10/08/2019.
//  Copyright © 2019 Yoel Lev. All rights reserved.
//

import UIKit

fileprivate typealias ContactDataSource  = UICollectionViewDiffableDataSource<CollectionViewController.Section, Contact>
fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CollectionViewController.Section, Contact>

class CollectionViewController: UIViewController {
    
    let cellId = "cellId"
    private var contacts = [Contact]()
    private var dataSource: ContactDataSource!
    private var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Diffable Data Source"
        
        createData()
        configureHierarchy()
        configureDataSource()
    }
    
}

//MARK: - Collection View Setup
extension CollectionViewController {
    
    private func createData() {
          for i in 0..<10 {
              contacts.append(Contact(name:"Contact \(i)", image: ""))
          }
      }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 8, trailing: 16)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
         
         collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
         collectionView.delegate = self
         collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         collectionView.backgroundColor = .systemBackground
         collectionView.register(ContactCell.self, forCellWithReuseIdentifier: cellId)
         view.addSubview(collectionView)
     }
    
    private func configureDataSource() {
        
        dataSource = ContactDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, contact) -> ContactCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ContactCell
            cell.contact = contact
            return cell
        })
        
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(self.contacts)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

//MARK: - Collection View Delegates
extension CollectionViewController: UICollectionViewDelegate  {
    
    fileprivate enum Section {
        case main
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)
         guard let contact = dataSource.itemIdentifier(for: indexPath) else { return }
        print(contact)
     }
    
}
