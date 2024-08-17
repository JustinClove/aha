//
//  MVLocationViewController.swift
//  FastVPN
//
//  Created by Justin on 2022/9/27.
//

import Foundation
//import JXCategoryView

enum LocationType: String {
    case free
    case vip

    var title: String {
        switch self {
        case .free: return "  Free"
        case .vip: return "Premium"
        }
    }
}

class  MVLocationViewController: LXBaseViewController {
    let typeArr:[LocationType] = [.free, .vip]
    var defaultType = LocationType.free
    
    lazy var freeTableVC: MVFreeViewController = {
        let vc = MVFreeViewController()
        vc.selectedBlock = { [unowned self] model in
            self.actionSelectNode(model)
        }
        return vc
    }()
    
    lazy var vipTableVC: MVVipViewController = {
        let vc = MVVipViewController()
        vc.selectedBlock = { [unowned self] model in
            self.actionSelectNode(model)
        }
        return vc
    }()
    
    lazy var categoryView: JXCategoryTitleImageView = {
        let margin = CGFloat(4)
        let categoryView = JXCategoryTitleImageView()
        categoryView.frame = CGRect(x: 20, y: 16, width: SCREEN_WIDTH - 2*20, height: 48)
        categoryView.titles = typeArr.map { $0.title }
        categoryView.imageInfoArray = ["", "icon_premium_normal"]
        categoryView.selectedImageInfoArray = ["", "vip_icon_18"]
        categoryView.imageTypes = [5, 3]
        categoryView.imageSize = CGSize(width: 12, height: 12)
        categoryView.cellSpacing = 0
        categoryView.cellWidth = (categoryView.width)/2
        categoryView.titleColor = UIColor.white
        categoryView.backgroundColor = .theme
        categoryView.layer.cornerRadius = 16
        categoryView.titleSelectedColor = .theme
        categoryView.titleFont = UIFont.regularSystemFont(ofSize: 16)
        categoryView.titleSelectedFont = UIFont.mediumSystemFont(ofSize: 16)
        categoryView.loadImageBlock = { imageView, imageName in
            imageView?.image = UIImage(named: imageName as! String)
        }
        self.view.addSubview(categoryView)
        
        let indicatorImageView = JXCategoryIndicatorBackgroundView()
        indicatorImageView.indicatorCornerRadius = 14
        indicatorImageView.indicatorColor = .white
        indicatorImageView.indicatorHeight = categoryView.height - margin
        indicatorImageView.indicatorWidth = categoryView.width/2
        indicatorImageView.indicatorWidthIncrement = -margin
        categoryView.indicators = [indicatorImageView]
        
        categoryView.contentScrollView = scrollView
        return categoryView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(16 + 48 + 10)
        }
        
        var lastVC: UIViewController?
        for (index,type) in typeArr.enumerated() {
            var vc: UIViewController!
            if type == .free {
                vc = freeTableVC
            } else {
                vc = vipTableVC
            }
            
            
            self.addChild(vc)
            scrollView.addSubview(vc.view)
            vc.view.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
                if let _lastVC = lastVC {
                    make.leading.equalTo(_lastVC.view.snp.trailing)
                } else {
                    make.leading.equalTo(0)
                }
                if index == typeArr.count - 1 {
                    make.trailing.equalTo(0)
                }
            }
            lastVC = vc
        }
        return scrollView
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Server List"
        self.view.backgroundColor = .backgroundColor
        self.view.addSubview(categoryView)

        if let location = MVConfigModel.current?.currentNode, location.free == 1 {
            defaultType = LocationType.free
        } else {
            defaultType = LocationType.vip
        }
        categoryView.defaultSelectedIndex = self.typeArr.firstIndex(of: self.defaultType) ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        appearance.backgroundImage = UIImage.init(color: .backgroundColor, size: CGSize(width: SCREEN_WIDTH, height: 100))
        appearance.shadowImage = UIImage()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(hexString: "#FFFFFF")!, .font: UIFont.mediumMontserratFont(ofSize: 20)]

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.backgroundColor = appearance.backgroundColor

        loadDataIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = categoryView.selectedIndex == 0
    }
    
    func loadDataIfNeeded() {
        if MVDataManager.shared.locationList.count == 0 {
            HUD.startLoading()
            MVDataManager.fetchLocationList(){_,_  in
                HUD.hide()
                                
                if MVDataManager.shared.locationList.count == 0 {
                    HUD.flash("No Services")
                } else {
                    self.freeTableVC.reloadData()
                    self.vipTableVC.reloadData()
                }
            }
        } else {
            MVDataManager.fetchLocationList(){_,_  in
                if MVDataManager.shared.locationList.count == 0 {
                } else {
                    self.freeTableVC.reloadData()
                    self.vipTableVC.reloadData()
                }
            }
        }
    }
    
    var delegate: HVLocationSelectedProtocol?
    func actionSelectNode(_ model: NodeModel) {
        MVConfigModel.current?.currentNode = model
        MVConfigModel.current?.saveToFile1()

        freeTableVC.tableView.reloadData()
        vipTableVC.tableView.reloadData()
        
        self.delegate?.actionDidSelectLocation(model)
        self.navigationController?.popViewController(animated: true)
    }
}


protocol HVLocationSelectedProtocol {
    func actionDidSelectLocation(_ model: NodeModel)
}
