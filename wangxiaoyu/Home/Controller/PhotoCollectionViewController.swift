//
//  PhotoCollectionViewController.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/19.
//

import UIKit

class PhotoCollectionViewController: UIViewController {
    var photoArray = [PhotoModel]()
    var currentItem = 0
    var lastContentOffset = 0
//    let photoCollectionView: UICollectionView = {
//        var cv = UICollectionView()
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 8
//        cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        return cv
//    }()
    
    let photoCollectionView = Tools.setUpCollectionView(0, 0, Int(K.screenHeight), Int(K.screenWidth), vertical: false)
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = photoArray.count
        pc.currentPage = currentItem
        return pc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.backgroundColor = UIColor.black
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionCell")
        
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view)
        }
        
    }
    

}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: K.screenWidth, height: K.screenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.imageView.image = photoArray[indexPath.item].image!
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
   
        print(photoCollectionView.contentOffset.x)
        let offsetX = photoCollectionView.contentOffset.x
        if lastContentOffset > Int(offsetX) {
            
            
        }else{
            print("forwards")
            let rem = offsetX.truncatingRemainder(dividingBy: K.screenWidth)
            
            let index = Int(offsetX / K.screenWidth)
            if rem  > K.screenWidth / 2 {
                photoCollectionView.contentOffset.x = CGFloat((index + 1)) * K.screenWidth
            }
        }
        
        lastContentOffset = Int(offsetX)
    }
    
}
