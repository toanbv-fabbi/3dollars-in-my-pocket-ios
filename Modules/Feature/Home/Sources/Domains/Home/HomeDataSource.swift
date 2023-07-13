import UIKit

final class HomeDataSource: UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem> {
    let viewModel: HomeViewModel
    
    init(collectionView: UICollectionView, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        collectionView.register([
            HomeStoreCardCell.self
        ])
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .storeCard(let storeCard):
                let cell: HomeStoreCardCell = collectionView.dequeueReuseableCell(indexPath: indexPath)
                
                cell.bind(storeCard: storeCard)
                return cell
            }
        }
    }
}
