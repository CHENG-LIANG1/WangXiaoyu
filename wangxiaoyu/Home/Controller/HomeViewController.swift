//
//  HomeViewController.swift
//  wangxioayu
//
//  Created by Cheng Liang(Louis) on 2022/1/27.
//

import UIKit
import SnapKit
import Photos
import SKPhotoBrowser
import SDCAlertView
import YPImagePicker

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, SKPhotoBrowserDelegate {

    
    let imgPicker = UIImagePickerController()

    func didSelect(image: UIImage?) {
        imageToAdd = image
    }
    
    var imageToAdd: UIImage?
    
    let photoCollectionView = Tools.setUpCollectionView(0, 0, Int(K.screenWidth) / 4, Int(K.screenWidth) / 4)
    
    var imageArray:[PhotoModel] = []
    
    var selectedImageIndex = 0
    
    var lastImageIndex = 0
    
    var selectedImageID = 0
    
    private let cache = NSCache<NSNumber, UIImage>()
    
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 22.5
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "AvenirNextCondensed-BoldItalic", size: 20)
        Tools.setHeight(btn, 45)
        Tools.setWidth(btn, 135)
        btn.setBackgroundColor(color: K.appBlue, forState: .normal)
        return btn
    }()
    

    
    
    


    @objc func addPressed(sender:UIButton){
        sender.showAnimation { [self] in
            
            
            config.library.maxNumberOfItems = 9
            config.library.defaultMultipleSelection = true
            config.showsPhotoFilters = false
            config.wordings.albumsTitle = "相册"
            config.wordings.cameraTitle = "相机"
            config.wordings.cancel = "取消"
            config.wordings.libraryTitle = "图库"
            config.wordings.done = "完成"
            config.wordings.next = "完成"
            config.isScrollToChangeModesEnabled = false
            config.library.mediaType = .photo
            config.library.preselectedItems = []
            config.startOnScreen = .library
            config.library.preSelectItemOnMultipleSelection = false
            config.icons.removeImage = UIImage(named: "delete")!
            config.colors.bottomMenuItemSelectedTextColor = K.appBlue
            config.colors.multipleItemsSelectedCircleColor = K.appBlue
            config.icons.multipleSelectionOnIcon = UIImage(named: "multipleOn")!

            let picker = YPImagePicker(configuration: config)

            picker.didFinishPicking { [unowned picker] items, cancelled in
                for item in items {
                    switch item {
                    case .photo(let photo):
                        imageArray.append(PhotoModel(photoID: lastImageIndex + 1, image: photo.image))
                        DBManager.shared.addImage(imageToAdd: photo.image)
                        lastImageIndex += 1
                    case .video(let video):
                        print(video)
                    }
                }
                picker.dismiss(animated: true) {
                    if items.count > 0 {
                        self.showToast(message: "已添加 \(items.count) 张图片", fontSize: 14, bgColor: K.brandGreen, textColor: .white, width: 130, height: 30, delayTime: 0.5)
                    }
                   
                }
                
                
            }
            present(picker, animated: true, completion: nil)
           
        }
    }
    

    

    
    
    override func viewWillAppear(_ animated: Bool) {
        imageArray = DBManager.shared.loadImages()
        lastImageIndex = imageArray[imageArray.count - 1].photoID!
        photoCollectionView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var config = YPImagePickerConfiguration()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "萝卜"
        definesPresentationContext = true
        self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayCloseButton = false
        
      
        photoCollectionView.backgroundColor = UIColor.init(named: "backgroundColor")
        
        view.addSubview(photoCollectionView)
        
        photoCollectionView.snp.makeConstraints { make in
            make.size.edges.equalTo(view)
        }
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
    
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addPressed(sender:)), for: .touchUpInside)
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-30)
        }
    
        
        
    }
    
    
    
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        
        let alert = AlertController(title: "是否删除这张照片？", message: "", preferredStyle: .alert)
        let cancelAction = AlertAction(title: "取消", style: .normal) { AlertAction in
       
        }
        
        let deleteAction = AlertAction(title: "删除", style: .destructive) { AlertAction  in
            DBManager.shared.deleteImage(id: self.selectedImageID)
            self.imageArray.remove(at: self.selectedImageIndex)

            self.dismiss(animated: true, completion: nil)
            self.showToast(message: "已删除", fontSize: 14, bgColor: .red, textColor: .white, width: 80, height: 30, delayTime: 0.1)
            self.photoCollectionView.reloadData()
            
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        alert.present()
    }
    

    
    
}

extension UIView {
    func traverseRadius(_ radius: Float) {
        layer.cornerRadius = CGFloat(radius)

        for subview: UIView in subviews {
            subview.traverseRadius(radius)
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
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var skImages = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(imageArray[indexPath.item].image!)
        selectedImageIndex = indexPath.item
        selectedImageID = imageArray[indexPath.item].photoID!
        
        skImages.append(photo)
        let browser = SKPhotoBrowser(photos: skImages)

        browser.delegate = self
    
        present(browser, animated: true, completion: nil)
        browser.updateDeleteButton(UIImage(named: "delete")!, size: CGSize(width: 60, height: 60))
        
    }
    

    
}

