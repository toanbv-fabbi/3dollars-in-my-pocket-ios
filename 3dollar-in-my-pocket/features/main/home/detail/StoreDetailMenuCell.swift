import UIKit
import RxSwift

class StoreDetailMenuCell: BaseTableViewCell {
  
  static let registerId = "\(StoreDetailMenuCell.self)"
  
  let menuStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    $0.isUserInteractionEnabled = true
  }
  
  override func setup() {
    self.selectionStyle = .none
    self.backgroundColor = .clear
    self.contentView.isUserInteractionEnabled = false
    self.addSubViews(menuStackView)
  }
  
  override func bindConstraints() {
    self.menuStackView.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(24)
      make.right.equalToSuperview().offset(-24)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  func addMenu(categories: [StoreCategory], menus: [Menu]) {
    if self.menuStackView.subviews.isEmpty {
      if categories.isEmpty {
        let emptyView = StoreDetailMenuEmptyView()
        
        self.menuStackView.addArrangedSubview(emptyView)
      } else {
        let subViews = self.subViewsFromMenus(categories: categories, menus: menus)
        
        for subView in subViews {
          self.menuStackView.addArrangedSubview(subView)
        }
        self.menuStackView.addArrangedSubview(StoreDetailMenuFooterView())
      }
    }
  }
  
  private func subViewsFromMenus(categories: [StoreCategory], menus: [Menu]) -> [UIView] {
    var subViews: [UIView] = []
    
    for category in categories {
      let categoryView = StoreDetailMenuCategoryView()
      var menuSubViews: [UIView] = []
      
      for menu in menus {
        if menu.category == category {
          let menuView = StoreDetailMenuView()
          
          menuView.bind(menu: menu)
          menuSubViews.append(menuView)
        }
      }
      categoryView.bind(category: category, isEmpty: menuSubViews.isEmpty)
      subViews.append(categoryView)
      subViews = subViews + menuSubViews
    }
    
    return subViews
  }
}
