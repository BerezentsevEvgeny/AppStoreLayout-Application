
import UIKit

class ViewController: UIViewController {
        
    // MARK:  Перечисление Секций
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Настройка CollectionView layout
        collectionView.collectionViewLayout = createLayout()
        
        // MARK: Регистрируем Cells
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        
        configureDataSource()
        
    }
    
    // Организуем Layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            switch section {
            case .promoted:
                // MARK: Promotes section layout
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
            default:
                return nil
            }
        }
        return layout
    }
    
    // MARK: Инициализируем dataSource
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            // Определяем секцию и затем ячейку для нее
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier, for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
            default:
                fatalError("Not yet implemented")
            }
        })
        
        // MARK: Определяем Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        sections = snapshot.sectionIdentifiers
        
        dataSource.apply(snapshot)
    }
    

    
    
}

