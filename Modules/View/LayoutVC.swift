//
//  LayoutVC.swift
//  SBINri
//
//  Created by Admin on 13/10/20.
//

import UIKit

class LayoutVC: UIViewController {
    var entity: Entity?
    var modelObjects: [HeaderItem] = [HeaderItem]()
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, Element>! = nil
    @IBOutlet var layoutCollectionView: UICollectionView!
    
    struct HeaderItem: Hashable {
        let viewType: String
        let title: String
        let element: [Element]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allOjects()
        navigationItem.title = Constant.navigationTitle
        configureCollectionView()
        configureDataSource()
    }
}

extension LayoutVC {
    
    func configureCollectionView() {
        
        layoutCollectionView.collectionViewLayout = generateLayout()
        layoutCollectionView.backgroundColor = .systemBackground
        layoutCollectionView.delegate = self
        layoutCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseIdentifer)
        layoutCollectionView.register(HorizontalItemCell.self, forCellWithReuseIdentifier: HorizontalItemCell.reuseIdentifer)
        layoutCollectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: Constant.header.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, Element>(collectionView: layoutCollectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, albumItem: Element) -> UICollectionViewCell? in
            
            let sectionType = modelObjects[indexPath.section].viewType
            if  (sectionType == viewType.horizontal.rawValue) {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalItemCell.reuseIdentifer, for: indexPath) as? HorizontalItemCell else { fatalError("Could not create new cell") }
                cell.featuredPhotoURL = albumItem.imageName
                cell.title = albumItem.name
                cell.totalNumberOfImages = albumItem.value?.count
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifer, for: indexPath) as? NewsCell else { fatalError("Could not create new cell") }
                cell.featuredPhotoURL = albumItem.imageName
                cell.title = albumItem.name
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:HeaderView.reuseIdentifier, for: indexPath) as? HeaderView
            else {
                fatalError("Cannot create header view")
            }
            
            supplementaryView.label.text = "\(modelObjects[indexPath.section].title) | \(modelObjects[indexPath.section].viewType)"
            return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [self] (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            
            let sectionLayoutKind = modelObjects[sectionIndex]
            if (sectionLayoutKind.viewType == viewType.horizontal.rawValue) {
                return self.generateHorizontalLayout(isWide: isWideView)
            } else {
                return self.generateVerticalLayout()
            }
        }
        return layout
    }
    
    func generateHorizontalLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Show one item plus peek on narrow screens, two items plus peek on wider screens
        let groupFractionalWidth = isWide ? 0.475 : 0.95
        let groupFractionalHeight: Float = isWide ? 1/3 : 2/3
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)), heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind:Constant.header.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func generateVerticalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.5)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constant.header.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<HeaderItem, Element> {
        var snapshot = NSDiffableDataSourceSnapshot<HeaderItem, Element>()
            // Create collection view section based on number of HeaderItem in modelObjects
        snapshot.appendSections(modelObjects)
        // Loop through each header item to append symbols to their respective section
        for headerItem in modelObjects {
            snapshot.appendItems(headerItem.element, toSection: headerItem)
        }
        return snapshot
    }
    
    func allOjects() {
        modelObjects = [HeaderItem]()
        if let entity = Utils.loadJson(filename: "page"), let items = entity.page {
            for item in items {
                // Put check here only for assigning a different BG image
                if (item.viewType == viewType.horizontal.rawValue) {
                    modelObjects.append(HeaderItem(viewType: item.viewType ?? "", title: item.title ?? "", element: getSectionObject(obj: item.value, imageName: "DSCF6612")))
                } else if (item.viewType == viewType.vertical.rawValue) {
                    modelObjects.append(HeaderItem(viewType: item.viewType ?? "", title: item.title ?? "", element: getSectionObject(obj: item.value, imageName: "DSCF6528")))
                } else {
                    
                }
            }
        }
    }
    
    func getSectionObject(obj: [Value]?, imageName: String) -> [Element] {
        var element = [Element]()
        if let items = obj {
            for item in items {
                element.append(Element(name: item.title ?? "", imageName: imageName, value: item.value ?? ""))
            }
        }
        return element
    }
}

extension LayoutVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
