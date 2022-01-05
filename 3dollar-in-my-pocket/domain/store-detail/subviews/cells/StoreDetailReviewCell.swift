import UIKit
import GoogleMobileAds
import AppTrackingTransparency

final class StoreDetailReviewCell: BaseTableViewCell {
    
    static let registerId = "\(StoreDetailReviewCell.self)"
    
    let adBannerView = GADBannerView().then {
        $0.isHidden = true
        $0.adUnitID = Bundle.admobUnitId
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let ratingView = RatingView()
    
    let moreButton = UIButton().then {
        $0.setImage(R.image.ic_more_horizontal(), for: .normal)
        $0.isHidden = true
    }
    
    private let titleLabel = TitleLabel(type: .small)
    
    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .bold(size: 12)
    }
    
    private let createdAtLabel = UILabel().then {
        $0.textColor = R.color.gray30()
        $0.font = .regular(size: 12)
    }
    
    private let replyLabel = UILabel().then {
        $0.textColor = R.color.gray90()
        $0.numberOfLines = 0
        $0.font = .regular(size: 14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.moreButton.isHidden = true
        self.adBannerView.delegate = nil
    }
    
    override func setup() {
        self.addSubViews([
            self.containerView,
            self.adBannerView,
            self.ratingView,
            self.moreButton,
            self.titleLabel,
            self.nameLabel,
            self.createdAtLabel,
            self.replyLabel
        ])
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        self.backgroundColor = .clear
    }
    
    override func bindConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(self.replyLabel).offset(16)
            make.bottom.equalToSuperview()
        }
        
        self.adBannerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview()
            make.height.equalTo(64)
        }
        
        self.ratingView.snp.makeConstraints { make in
            make.left.equalTo(self.containerView).offset(17)
            make.top.equalTo(self.containerView).offset(15)
        }
        
        self.createdAtLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.ratingView)
            make.right.equalTo(self.containerView).offset(-16)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.containerView).offset(16)
            make.top.equalTo(self.ratingView.snp.bottom).offset(14)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).offset(8)
        }
        
        self.replyLabel.snp.makeConstraints { make in
            make.left.equalTo(self.containerView).offset(16)
            make.right.equalTo(self.containerView).offset(-16)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        
        self.moreButton.snp.makeConstraints { make in
            make.right.equalTo(self.containerView).offset(-12)
            make.bottom.equalTo(self.containerView).offset(-12)
            make.width.height.equalTo(24)
        }
    }
    
    func bind(review: Review?, userId: Int) {
        if let review = review {
            self.ratingView.bind(rating: review.rating)
            self.ratingView.isHidden = false
            self.titleLabel.bind(title: review.user.medal.name)
            self.nameLabel.text = review.user.name
            self.replyLabel.text = review.contents
            self.createdAtLabel.text = DateUtils.toReviewFormat(dateString: review.createdAt)
            self.adBannerView.isHidden = true
            self.replyLabel.isHidden = false
            self.createdAtLabel.isHidden = false
            self.titleLabel.isHidden = false
            self.nameLabel.isHidden = false
            self.containerView.isHidden = false
            self.moreButton.isHidden = userId != review.user.userId
        } else {
            self.containerView.isHidden = true
            self.adBannerView.isHidden = false
            self.ratingView.isHidden = true
            self.replyLabel.isHidden = true
            self.createdAtLabel.isHidden = true
            self.titleLabel.isHidden = true
            self.nameLabel.isHidden = true
            self.moreButton.isHidden = true
            self.loadAd()
        }
    }
    
    private func loadAd() {
        let viewWidth = UIScreen.main.bounds.width
        
        self.adBannerView.adSize
            = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.adBannerView.delegate = self
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                self.adBannerView.load(GADRequest())
            })
        } else {
            self.adBannerView.load(GADRequest())
        }
    }
}

extension StoreDetailReviewCell: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
