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
import SCLAlertView
import Toast_Swift

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {



    
    let albumCollectionView = Tools.setUpCollectionView(24, 12, Int(K.screenWidth - 64) / 7 * 3, Int(K.screenWidth - 64) / 3, vertical: true)

//    lazy var imageArray:[PhotoModel] = []
//    
//    var selectedImageIndex = 0
//    
//    var lastImageIndex = 0
//    
//    var selectedImageID = 0a
    
    
    var mode = UIView.ContentMode.scaleAspectFit
    var modeRadius = 0

    var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    var albumNameTextField = UITextField()

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
        

//        view.addSubview(modeButton)
//        modeButton.addTarget(self, action: #selector(modePressed(sender:)), for: .touchUpInside)
//        modeButton.snp.makeConstraints { make in
//            make.bottom.equalTo(view).offset(-4)
//            make.right.equalTo(view).offset(-16)
//        }
        
        Tools.setHeight(view, 100)
        
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
    
    var albumTitles = [String]()
    
    lazy var albums = [Album]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        albums = []
        
        for title in albumTitles {
            let rows = DBManager.shared.getNumOfRows(tableName: title)
            let coverImamge = DBManager.shared.getTheFirstImage(tableName: title)
            let album = Album(name: title, coverImage: coverImamge, numOfRows: rows)
            albums.append(album)
        }
        
        self.albumCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        albumTitles = DBManager.shared.getAllTableNames()
        
       
        configureViews()
        layoutViews()
    }
    
    func configureViews(){
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.navigationController!.navigationBar.tintColor = UIColor.init(named: "textColor")

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

        self.albumCollectionView.backgroundColor = UIColor(named: "backgroundColor")
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")

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
        
        view.addSubview(albumCollectionView)
        albumCollectionView.snp.makeConstraints { make in
            make.top.equalTo(appBar.snp_bottomMargin).offset(16)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
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
    
    @objc func addPressed(sender:UIButton){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false,
            contentViewCornerRadius: 15, buttonCornerRadius: 10,
            hideWhenBackgroundViewIsTapped: true
        )

        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)


        // Creat the subview
        let subview = UIView(frame: CGRect(x:0,y:0,width:216,height:60))
        let x = (subview.frame.width - 180) / 2

        // Add textfield 1
        albumNameTextField = UITextField(frame: CGRect(x:x, y:10, width:180,height:40))
        albumNameTextField.layer.borderColor = UIColor.gray.cgColor
        albumNameTextField.layer.borderWidth = 1
        albumNameTextField.layer.cornerRadius = 10
        albumNameTextField.textColor = .black
        albumNameTextField.textAlignment = NSTextAlignment.center
        albumNameTextField.delegate = self

        
        subview.addSubview(albumNameTextField)

        // Add the subview to the alert's UI property
        alert.customSubview = subview
        alert.addButton("确认") { [self] in
            print(albumNameTextField.text)
            if albumTitles.contains(albumNameTextField.text!) {
                self.view.makeToast("创建失败！相册已存在", duration: 3.0, position: .center)
                
            }else{
                
                DBManager.shared.addAlbum(albumTableName: albumNameTextField.text!)
                let album = Album(name: albumNameTextField.text!, coverImage: nil, numOfRows: 0)
                albumTitles.append(albumNameTextField.text!)
                albums.append(album)
                self.albumCollectionView.reloadData()
            }
            

        }


        alert.showInfo("添加相册", subTitle: "")

        }
    }
    
    
extension HomeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        albumNameTextField.layer.borderColor = K.appBlue.cgColor
        albumNameTextField.layer.borderWidth = 1.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        albumNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        albumNameTextField.layer.borderWidth = 1
    }
}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.albumTitleLabel.text = albums[indexPath.item].name!
        cell.imageView.image = albums[indexPath.item].coverImage ?? UIImage(named: "placeholder")
        cell.photoNumLabel.text = "\(albums[indexPath.item].numOfRows ?? 0)"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = PhotoCollectionViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.albumTitle = albums[indexPath.item].name!
        self.screenShotCapsule.isHidden = true
        navigationController?.pushViewController(vc, animated: true)

        
    }
    

    
}
