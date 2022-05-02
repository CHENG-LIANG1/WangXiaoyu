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
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 22.5
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "AvenirNextCondensed-BoldItalic", size: 20)
        Tools.setHeight(btn, 45)
        Tools.setWidth(btn, 135)
        btn.setBackgroundColor(color: .red, forState: .normal)
        return btn
    }()


    
    
    @objc func addPressed(sender:UIButton){
        sender.showAnimation { [self] in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    imgPicker.delegate = self
                    imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true, completion: nil)
               }
                Tools.Viberation.heavy.viberate()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
            
            imageArray.append(PhotoModel(photoID: lastImageIndex + 1, image: image))
            
            DBManager.shared.addImage(imageToAdd: image)
            
            self.photoCollectionView.reloadData()

        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        imageArray = DBManager.shared.loadImages()
        lastImageIndex = imageArray[imageArray.count - 1].photoID!
        photoCollectionView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "萝卜"
        definesPresentationContext = true
        self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarController?.tabBar.standardAppearance
        
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        
    
        
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
    }
    

    
}

