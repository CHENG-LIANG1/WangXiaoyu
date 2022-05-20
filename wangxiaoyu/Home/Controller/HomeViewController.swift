//
//  HomeViewController.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit
import SnapKit
import Photos
import SDCAlertView
import HXPHPicker

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    let photoCollectionView = Tools.setUpCollectionView(8, 8, Int(K.screenWidth - 40) / 4, Int(K.screenWidth - 40) / 4, vertical: true)
    
    lazy var imageArray:[PhotoModel] = []
    
    var selectedImageIndex = 0
    
    var lastImageIndex = 0
    
    var selectedImageID = 0
    
    
    var mode = UIView.ContentMode.scaleAspectFit
    var modeRadius = 0

    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))

    var appBar: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "相册"
        label.textColor = UIColor.init(named: "textColor")
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(label)
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(0)
        }
        
        let modeButton: UIButton = {
            let btn = UIButton()
            btn.layer.cornerRadius = 12.5
            btn.setTitle("Mode", for: .normal)
            btn.titleLabel?.font = UIFont.init(name: "AvenirNextCondensed-BoldItalic", size: 14)
            Tools.setHeight(btn, 25)
            Tools.setWidth(btn, 60)
            btn.setBackgroundColor(color: K.brandDark, forState: .normal)
            return btn
        }()
        
        view.addSubview(modeButton)
        modeButton.addTarget(self, action: #selector(modePressed(sender:)), for: .touchUpInside)
        modeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-4)
            make.right.equalTo(view).offset(-16)
        }
        
        Tools.setHeight(view, 80)
        
        return view
    }()
    
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 30
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "AvenirNextCondensed-BoldItalic", size: 20)
        Tools.setHeight(btn, 60)
        Tools.setWidth(btn, 60)
        btn.setBackgroundColor(color: K.appBlue, forState: .normal)
        return btn
    }()
    
    
    let screenShotCapsule: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "xiaoyu")
        Tools.setHeight(view, 20)
        Tools.setWidth(view, 80)
        
        let lbl = UILabel()
        lbl.text = "遇记App"
        lbl.textColor = .white

        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        view.layer.cornerRadius = 10
        view.backgroundColor = K.appBlue
        
        return view
    }()
    
    var shouldFit = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        imageArray = DBManager.shared.loadImages()
        lastImageIndex = imageArray[imageArray.count - 1].photoID!
        self.photoCollectionView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        layoutViews()
    }
    
    func configureViews(){
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.shouldFit = UserDefaults.standard.bool(forKey: "mode")

        if shouldFit {
            mode = .scaleAspectFit
            modeRadius = 0
        }else {
            mode = .scaleAspectFill
            modeRadius = 10
        }



        self.view.backgroundColor = UIColor.init(named: "backgroundColor")
        definesPresentationContext = true

        self.photoCollectionView.backgroundColor = UIColor(named: "backgroundColor")
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        addButton.addTarget(self, action: #selector(addPressed(sender:)), for: .touchUpInside)



        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func layoutViews(){
        
        view.addSubview(appBar)
        appBar.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(appBar.snp_bottomMargin).offset(16)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalTo(view).offset(0)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-25)
            make.bottom.equalTo(view).offset(-100)
        }
        
        view.addSubview(screenShotCapsule)
        screenShotCapsule.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top).offset(5)
            make.centerX.equalTo(view)
        }
        
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    @objc func appResignActive() {
        view.addSubview(blurEffectView)
    }
    
    @objc func appBecameActive() {
        blurEffectView.removeFromSuperview()
    }
    
    @objc func modePressed(sender: UIButton){
        sender.showAnimation { [self] in
            if mode == .scaleAspectFit {
                mode = .scaleAspectFill
                modeRadius = 10
                UserDefaults.standard.set(false, forKey: "mode")
                self.photoCollectionView.reloadData()
            }else{
                mode = .scaleAspectFit
                modeRadius = 0
                UserDefaults.standard.set(true, forKey: "mode")
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    func presentPickerController() {
        // Set the configuration consistent with the WeChat theme
        let config = PhotoTools.getWXPickerConfig()
        config.allowSelectedTogether = false
        config.selectOptions = .livePhoto
        

        let pickerController = PhotoPickerController(picker: config)
        pickerController.pickerDelegate = self

        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func addPressed(sender:UIButton){
        sender.showAnimation { [self] in
            presentPickerController()
           
           
        }
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.imageView.image = imageArray[indexPath.item].image!
        cell.imageView.contentMode = self.mode
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = CGFloat(modeRadius)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var skImages = [SKPhoto]()
//        let photo = SKPhoto.photoWithImage(imageArray[indexPath.item].image!)
        selectedImageIndex = indexPath.item
        selectedImageID = imageArray[indexPath.item].photoID!
//
//        skImages.append(photo)
//        let browser = SKPhotoBrowser(photos: skImages)
//
//        browser.delegate = self
//
//        present(browser, animated: true, completion: nil)
//        browser.updateDeleteButton(UIImage(named: "delete")!, size: CGSize(width: 60, height: 60))
//
        let image = imageArray[indexPath.item].image
        let vc = PhotoViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.currenttPage = indexPath.item
        vc.imageArray = imageArray
        vc.selectedImageIndex = self.selectedImageIndex
//        let vc = PhotoCollectionViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        vc.currentItem = indexPath.item
//        vc.photoArray = imageArray
        present(vc, animated: true, completion: nil)
        
    }
    

    
}


extension HomeViewController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    /// - Parameters:
    ///   - pickerController: 对应的 PhotoPickerController
    ///   - result: 选择的结果
    ///     result.photoAssets  选择的资源数组
    ///     result.isOriginal   是否选中原图
    func pickerController(_ pickerController: PhotoPickerController,
                            didFinishSelection result: PickerResult) {
        
        
        result.getImage { (image, photoAsset, index) in
            if let image = image {
                print("success", image)
            }else {
                print("failed")
            }
        } completionHandler: { [self] (images) in
            
            for image in images{
                imageArray.append(PhotoModel(photoID: lastImageIndex + 1, image: image))
                DBManager.shared.addImage(imageToAdd: image)
                lastImageIndex += 1
            }

            self.photoCollectionView.reloadData()
            print(images)
        }
        

    }
    
    /// 点击取消时调用
    /// - Parameter pickerController: 对应的 PhotoPickerController
    func pickerController(didCancel pickerController: PhotoPickerController) {
        
    }
}
