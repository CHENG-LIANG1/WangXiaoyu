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
        print("dismissed")
        self.dismiss(animated: true, completion: nil)
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = .black
        view.addSubview(photoScrollView)
        photoScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        view.addSubview(pageControl)
        pageControl.pinTo(view)
        
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIImageView? {
        let imgView = UIImageView()
        imgView.image = imageArray[pageControl.currentPage].image
        return imgView
    }
       
    
    
}
