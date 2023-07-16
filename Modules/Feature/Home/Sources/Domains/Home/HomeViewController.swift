import UIKit
import Combine

import Common
import DesignSystem
import NMapsMap

typealias HomeStoreCardSanpshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>

public final class HomeViewController: BaseViewController {
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    private lazy var dataSource = HomeDataSource(collectionView: homeView.collectionView, viewModel: viewModel)
    private var markers: [NMFMarker] = []
    
    private var isFirstLoad = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // TODO: 태그 정의 필요
        tabBarItem = UITabBarItem(title: nil, image: DesignSystemAsset.Icons.homeSolid.image, tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func instance() -> HomeViewController {
        return HomeViewController()
    }
    
    public override func loadView() {
        view = homeView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.collectionView.delegate = self
        homeView.mapView.addCameraDelegate(delegate: self)
        viewModel.input.viewDidLoad.send(())
    }
    
    public override func bindViewModelInput() {
        // TODO: 다른 화면 구현 후 바인딩 필요
//        let selectCategory = PassthroughSubject<Category?, Never>()
//        let searchByAddress = PassthroughSubject<CLLocation, Never>()
//        let onTapCurrentMarker = PassthroughSubject<Void, Never>()
        
        homeView.sortingButton.sortTypePublisher
            .subscribe(viewModel.input.onToggleSort)
            .store(in: &cancellables)
        
        homeView.onlyBossToggleButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.onTapOnlyBoss)
            .store(in: &cancellables)
        
        homeView.researchButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.onTapResearch)
            .store(in: &cancellables)
        
        homeView.currentLocationButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.onTapCurrentLocation)
            .store(in: &cancellables)
        
        homeView.researchButton
            .controlPublisher(for: .touchUpInside)
            .mapVoid
            .subscribe(viewModel.input.onTapResearch)
            .store(in: &cancellables)
        
        if let layout = homeView.collectionView.collectionViewLayout as? HomeCardFlowLayout {
            layout.currentIndexPublisher
                .subscribe(viewModel.input.selectStore)
                .store(in: &cancellables)
        }
    }
    
    public override func bindViewModelOutput() {
        viewModel.output.address
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, address in
                owner.homeView.addressButton.bind(address: address)
            }
            .store(in: &cancellables)
        
        viewModel.output.isHiddenResearchButton
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, isHidden in
                owner.homeView.setHiddenResearchButton(isHidden: isHidden)
            }
            .store(in: &cancellables)
        
        viewModel.output.cameraPosition
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, location in
                owner.homeView.moveCamera(location: location)
            }
            .store(in: &cancellables)
        
        viewModel.output.storeCards
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, storeCards in
                let section = HomeSection(items: storeCards.map { HomeSectionItem.storeCard($0) })
                
                owner.updateDataSource(section: [section])
                
            }
            .store(in: &cancellables)
        
        viewModel.output.scrollToIndex
            .combineLatest(viewModel.output.storeCards)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, storeCardWithSelectIndex in
                let (selectIndex, storeCards) = storeCardWithSelectIndex
                guard storeCards.count > selectIndex else { return }
                
                let indexPath = IndexPath(row: selectIndex, section: 0)
                
                owner.selectMarker(selectedIndex: selectIndex, storeCards: storeCards)
                owner.homeView.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func updateDataSource(section: [HomeSection]) {
        var snapshot = HomeStoreCardSanpshot()
        
        section.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.items)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func selectMarker(selectedIndex: Int?, storeCards: [StoreCard]) {
        clearMarker()
        
        for value in storeCards.enumerated() {
            let marker = NMFMarker()
            
            if selectedIndex == value.offset {
                marker.width = 32
                marker.height = 40
                marker.iconImage = NMFOverlayImage(image: ImageProvider.image(name: "icon_marker_focused"))
            } else {
                marker.width = 24
                marker.height = 24
                marker.iconImage = NMFOverlayImage(image: ImageProvider.image(name: "icon_marker_unfocused"))
            }
            guard let latitude = value.element.location?.latitude,
                  let longitude = value.element.location?.longitude else { break }
            let position = NMGLatLng(lat: latitude, lng: longitude)
            
            marker.position = position
            marker.mapView = homeView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.viewModel.input.onTapMarker.send(value.offset)
                return true
            }
            markers.append(marker)
        }
    }
    
    private func clearMarker() {
        for marker in self.markers {
            marker.mapView = nil
        }
        self.markers.removeAll()
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    public func mapView(
        _ mapView: NMFMapView,
        cameraWillChangeByReason reason: Int,
        animated: Bool
    ) {
        if reason == NMFMapChangedByGesture {
            let mapLocation = CLLocation(
                latitude: mapView.cameraPosition.target.lat,
                longitude: mapView.cameraPosition.target.lng
            )
            let distance = mapView
                .contentBounds
                .boundsLatLngs[0]
                .distance(to: mapView.contentBounds.boundsLatLngs[1])
            
            viewModel.input.changeMaxDistance.send(distance / 3)
            viewModel.input.changeMapLocation.send(mapLocation)
        } else if reason == NMFMapChangedByDeveloper && isFirstLoad {
            isFirstLoad = false
            let distance = mapView
                .contentBounds
                .boundsLatLngs[0]
                .distance(to: mapView.contentBounds.boundsLatLngs[1])
            
            viewModel.input.onMapLoad.send(distance)
        }
    }
    
    public func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            let mapLocation = CLLocation(
                latitude: mapView.cameraPosition.target.lat,
                longitude: mapView.cameraPosition.target.lng
            )
            let distance = mapView
                .contentBounds
                .boundsLatLngs[0]
                .distance(to: mapView.contentBounds.boundsLatLngs[1])
            
            viewModel.input.changeMaxDistance.send(distance / 3)
            viewModel.input.changeMapLocation.send(mapLocation)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.onTapStore.send(indexPath.row)
    }
}
