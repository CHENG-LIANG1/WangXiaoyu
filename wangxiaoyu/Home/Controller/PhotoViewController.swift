//
//  PhotoViewController.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/18.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var currenttPage = 0
    var imageArray = [PhotoModel]()
    
    func createImagePageView(image: UIImage) -> UIView{
        let view = UIView()
        let imgV = UIImageView()
        imgV.image = image
        imgV.contentMode = .scaleAspectFit
        view.addSubview(imgV)
        imgV.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }

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
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: 1.0)
        
        for i in 0..<pages.count {
            scrollView.addSubview(pages[i])
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        print(currenttPage)
        pc.currentPage = currenttPage
        pc.addTarget(self, action: #selector(pageControlHandler(sender:)), for: .touchUpInside)
        return pc
    }()
    
    @objc
    func pageControlHandler(sender: UIPageControl){
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        print(currenttPage)
        view.addSubview(pageControl)
        pageControl.pinTo(view)
        
        scrollView.contentOffset.x = CGFloat(currenttPage) * K.screenWidth
    }


}

extension PhotoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
