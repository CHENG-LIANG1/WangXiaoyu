//
//  PhotoViewController.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/18.
//

import UIKit
import ZoomImageView

class PhotoViewController: UIViewController {
    
    var currenttPage = 0
    var imageArray = [PhotoModel]()
    var offset = 8
    var selectedImageIndex = 0

    let moreButton = Tools.setUpButtonWithSystemImage(systemName: "ellipsis.circle.fill", width: 37, height: 35, color: .gray)
    
    
    func createImagePageView(image: UIImage) -> UIView{
        let view = UIView()
        let imgV = ZoomImageView()
        
        
        imgV.image = image
        imgV.isUserInteractionEnabled = true
        imgV.contentMode = .scaleAspectFit

        view.addSubview(imgV)

        imgV.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.right.equalTo(-offset)
            make.left.equalTo(offset)
        }
        

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        tap.cancelsTouchesInView = false
        imgV.addGestureRecognizer(tap)
        
        return view
    }
    
    func createPages() -> [UIView]{
        var views = [UIView]()
        for i in 0..<imageArray.count {
            let view = createImagePageView(image: imageArray[i].image!)
            views.append(view)
        }
            
        return views
    }
    
    lazy var pages = createPages()
    
    
    lazy var photoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: (view.frame.width + CGFloat(offset)) * CGFloat(pages.count), height: view.frame.height * 1.0)
        scrollView.maximumZoomScale = 4.0
        for i in 0..<pages.count {
            scrollView.addSubview(pages[i])
            
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)

            
        }
        
        scrollView.delegate = self
//
//        let recognizer = UITapGestureRecognizer(target: self,
//                                                action: #selector(onDoubleTap(_:)))
//        recognizer.numberOfTapsRequired = 2
//        scrollView.addGestureRecognizer(recognizer)
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPage = currenttPage
        pc.addTarget(self, action: #selector(pageControlHandler(sender:)), for: .touchUpInside)
        return pc
    }()
    
    @objc
    func pageControlHandler(sender: UIPageControl){
        photoScrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    @objc
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func morePressed(sender: UIButton){
        sender.showAnimation { [self] in
            let bottomSheet = ImageBottomSheet()
            bottomSheet.tartgetImage = imageArray[pageControl.currentPage].image!
            bottomSheet.selectedImageID = imageArray[pageControl.currentPage].photoID!
            self.present(bottomSheet, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func photoDeleted(){
//        self.showToast(message: "已删除", fontSize: 14, bgColor: K.red, textColor: .white, width: 80, height: 30, delayTime: 0.1)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(photoDeleted), name: NSNotification.Name.init(rawValue: "deletePhoto"), object: nil)
        self.view.backgroundColor = .black
        view.addSubview(photoScrollView)
        photoScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        
        view.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(morePressed(sender:)), for: .touchUpInside)
        moreButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-40)
            make.right.equalTo(view).offset(-15)
        }
        
        photoScrollView.contentOffset.x = CGFloat(currenttPage) * K.screenWidth
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == photoScrollView {
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
            pageControl.currentPage = Int(pageIndex)
            
        }

    }

    
}
