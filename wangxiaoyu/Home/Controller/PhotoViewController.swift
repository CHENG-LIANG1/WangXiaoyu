//
//  PhotoViewController.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/5/18.
//

import UIKit
import ZoomImageView
import SDCAlertView

class PhotoViewController: UIViewController {
    
    var currenttPage = 0
    var imageArray = [PhotoModel]()
    var offset = 8
    var selectedImageIndex = 0

    let moreButton = Tools.setUpButtonWithSystemImage(systemName: "ellipsis.circle.fill", width: 37, height: 35, color: .gray)
    var lastOffset = 0
    
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(sender:)))
        
        imgV.addGestureRecognizer(longPress)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        

        
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
        scrollView.contentSize = CGSize(width: (view.frame.width + CGFloat(offset)) * CGFloat(pages.count), height: view.frame.height * 1.00)
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
//            let bottomSheet = ImageBottomSheet()
//            bottomSheet.tartgetImage = imageArray[pageControl.currentPage].image!
//            bottomSheet.selectedImageID = imageArray[pageControl.currentPage].photoID!
//            self.present(bottomSheet, animated: true, completion: nil)
            displayActionSheet()
        }
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                print("Swiped down")
                self.dismiss(animated: true, completion: nil)
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    @objc func photoDeleted(){
//        self.showToast(message: "已删除", fontSize: 14, bgColor: K.red, textColor: .white, width: 80, height: 30, delayTime: 0.1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageLongPressed(sender: UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizer.State.began {

            displayActionSheet()
        }
    
        
    }
    
    
    @objc func saveCompleted(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {
            print("ERROR: \(error)")
        }else {
            self.showToast(message: "已下载", fontSize: 14, bgColor: K.brandGreen, textColor: .white, width: 80, height: 30, delayTime: 0.1)
        }
    }
   
   func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
     }
   
    
    func displayActionSheet(){
        Tools.Viberation.heavy.viberate()
        let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "保存图片", style: .default, handler: { UIAlertAction in
            self.writeToPhotoAlbum(image: self.imageArray[self.pageControl.currentPage].image!)
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "分享图片", style: .default, handler: { [self] UIAlertAction in
            
            let imageToShare = [ imageArray[pageControl.currentPage].image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToTwitter ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "删除图片", style: .destructive, handler: { UIAlertAction in
            self.removePhoto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { UIAlertAction in
            
        }))
        
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func removePhoto() {

        let alert = AlertController(title: "是否删除这张照片？", message: "", preferredStyle: .alert)
        let cancelAction = AlertAction(title: "取消", style: .normal) { AlertAction in
       
        }
        
        let deleteAction = AlertAction(title: "删除", style: .destructive) { [self] AlertAction  in
            DBManager.shared.deleteImage(id: imageArray[pageControl.currentPage].photoID!, albumName: "所有图片")
            self.dismiss(animated: true, completion: nil )
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "deletePhoto"), object: nil )

        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        alert.present()
        

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
