import UIKit

import Common
import DesignSystem
import Model

final class StoreDetailVisitCell: BaseCollectionViewCell {
    enum Layout {
        static func calculateHeight(historyCount: Int) -> CGFloat {
            let summaryViewHeight = StoreDetailVisitSummryView.Layout.size.height
            let historyViewHeight = StoreDetailVisitHistoryView.Layout.calculateHeight(count: historyCount)
            let space: CGFloat = 8
            
            return summaryViewHeight + space + historyViewHeight
        }
    }
    
    private let successSummaryView = StoreDetailVisitSummryView()
    
    private let failSummaryView = StoreDetailVisitSummryView()
    
    private let historyView = StoreDetailVisitHistoryView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        historyView.prepareForReuse()
    }
    
    override func setup() {
        contentView.addSubViews([
            successSummaryView,
            failSummaryView,
            historyView
        ])
    }
    
    override func bindConstraints() {
        successSummaryView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalTo(snp.centerX).offset(-4)
            $0.top.equalToSuperview()
            $0.size.equalTo(StoreDetailVisitSummryView.Layout.size)
        }
        
        failSummaryView.snp.makeConstraints {
            $0.left.equalTo(snp.centerX).offset(4)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(successSummaryView)
            $0.size.equalTo(StoreDetailVisitSummryView.Layout.size)
        }
        
        historyView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(successSummaryView.snp.bottom).offset(8)
        }
    }
    
    func bind(_ visit: StoreDetailVisit) {
        successSummaryView.bind(.success(visit.existsCounts))
        failSummaryView.bind(.fail(visit.notExistsCounts))
        historyView.bind(visit.histories, totalCount: visit.existsCounts + visit.notExistsCounts)
    }
}
