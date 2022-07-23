//
//  PhotoCollectionViewController.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/20.
//

import UIKit
import SnapKit
import Photos
import SDCAlertView
import HXPHPicker
class PhotoCollectionViewController: UIViewController {
    let photoCollectionView = Tools.setUpCollectionView(8, 8, Int(K.screenWidth - 40) / 4, Int(K.screenWidth - 40) / 4, vertical: true)
    
    lazy var imageArray:[PhotoModel] = []
    
    var selectedImageIndex = 0
    
    var lastImageIndex = 0
    
    var selectedImageID = 0
    
    var albumTitle = ""
    
    var menu = UIMenu()
    
    var menuButton = UIButton()
    
    let circleImage = Tools.setUpButtonWithSystemImage(systemName: "circle", width: 15, height: 15, color: .lightGray)
    
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
    
    
    let doneButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 30
        btn.setTitle("Delete", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "AvenirNextCondensed-BoldItalic", size: 20)
        Tools.setHeight(btn, 60)
        Tools.setWidth(btn, 60)
        btn.setBackgroundColor(color: K.red, forState: .normal)
        return btn
    }()
    
    
    
    let titleLabel = UILabel()

        
    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
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
    
    
    let backButton = Tools.setUpButtonWithSystemImage(systemName: "chevron.backward", width: 35, height: 35, color: .black)
    
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func multiSelectionMode(){
        self.addButton.isHidden = !self.addButton.isHidden
        self.doneButton.isHidden = !self.doneButton.isHidden
        self.photoCollectionView.allowsMultipleSelection = !self.photoCollectionView.allowsMultipleSelection
        
        setupMenu()
        
        self.menuButton.menu = menu
        
        if !addButton.isHidden {
            self.photoCollectionView.deselectAllItems(animated: true)
        }

    }
    
    func presentPickerController() {
        // Set the configuration consistent with the WeChat theme
        let config = PhotoTools.getWXPickerConfig()
        config.allowSelectedTogether = false
        

        let pickerController = PhotoPickerController(picker: config)
        pickerController.pickerDelegate = self

        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func addPressed(sender:UIButton){
        sender.showAnimation { [self] in
            presentPickerController()
        }
    }
    
    @objc func morePressed(){
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        imageArray = DBManager.shared.loadImages(albumName: albumTitle)
        if imageArray.count > 0 {
            lastImageIndex = imageArray[imageArray.count - 1].photoID!
        }

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isHidden = false
        self.photoCollectionView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.photoCollectionView.backgroundColor = UIColor(named: "backgroundColor")
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        

        self.title = albumTitle
        menuButton = UIButton()
        let dotsImage = UIImage(systemName: "ellipsis")?.withConfiguration(UIImage.SymbolConfiguration.init(scale: .large)).withRenderingMode(.alwaysOriginal).withTintColor(.black)

        menuButton.setImage(dotsImage, for: .normal)
        
        let menuBarItem = UIBarButtonItem(customView: menuButton)
     
        self.navigationItem.rightBarButtonItem = menuBarItem
        
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.bottom.equalTo(view).offset(0)
        }
        
        addButton.addTarget(self, action: #selector(addPressed(sender:)), for: .touchUpInside)
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-25)
            make.bottom.equalTo(view).offset(-100)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-25)
            make.bottom.equalTo(view).offset(-100)
        }
        
        doneButton.isHidden = true
        
        setupMenu()
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func appResignActive() {
            view.addSubview(blurEffectView)
        }
        
    @objc func appBecameActive() {
            blurEffectView.removeFromSuperview()
        }
    
    func setupMenu(){
        var title = "多选删除"
        if self.photoCollectionView.allowsMultipleSelection {
            title = "取消"
        }else{
            title = "多选删除"
        }
        
        
        let multiMode = UIAction(title: title, image: nil, attributes: [.destructive]) { (action) in
            self.multiSelectionMode()
            self.photoCollectionView.deselectAllItems(animated: false)
            self.photoCollectionView.reloadData()
         }


         menu = UIMenu(title: "", options: .displayInline, children: [multiMode])
 
    }

}


extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.imageView.image = imageArray[indexPath.item].image!
        cell.imageView.layer.cornerRadius = CGFloat(10)
        
        cell.isSelected = false
        cell.toggoleSelection()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var skImages = [SKPhoto]()
//        let photo = SKPhoto.photoWithImage(imageArray[indexPath.item].image!)
        selectedImageIndex = indexPath.item
        selectedImageID = imageArray[indexPath.item].photoID!
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        if !self.photoCollectionView.allowsMultipleSelection{
            let image = imageArray[indexPath.item].image
            let vc = PhotoViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            vc.currenttPage = indexPath.item
            vc.imageArray = imageArray
            vc.selectedImageIndex = self.selectedImageIndex
            present(vc, animated: true, completion: nil)
        }else {
//            cell.imageView.layer.borderWidth = 10
            cell.toggoleSelection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
//        cell.imageView.layer.borderWidth = 0
        cell.toggoleSelection()
    }
    
    

    
}



extension PhotoCollectionViewController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    /// - Parameters:
    ///   - pickerController: 对应的 PhotoPickerController
    ///   - result: 选择的结果
    ///     result.photoAssets  选择的资源数组
    ///     result.isOriginal   是否选中原图
    func pickerController(_ pickerController: PhotoPickerController,
                            didFinishSelection result: PickerResult) {
        for item in result.photoAssets {
            if item.mediaType == .photo {
                imageArray.append(PhotoModel(photoID: lastImageIndex + 1, image: item.originalImage))
                DBManager.shared.addImage(imageToAdd: item.originalImage!, albumName: "所有图片")
                DBManager.shared.addImage(imageToAdd: item.originalImage!, albumName: albumTitle)
                lastImageIndex += 1
                self.photoCollectionView.reloadData()
            }else{
                print("it's a video")
            }
        }

        

    }
    
    /// 点击取消时调用
    /// - Parameter pickerController: 对应的 PhotoPickerController
    func pickerController(didCancel pickerController: PhotoPickerController) {
        
    }
}
