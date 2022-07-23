//
//  DBManager.swift
//  wangxiaoyu
//
//  Created by Cheng Liang(Louis) on 2022/4/30.
//

import ObjectiveC
import UIKit


struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    var pathToDatabase: String!
    var database: FMDatabase!

    func getDocumentDirectoryPath() -> URL {
      let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let docDirectoryPath = arrayPaths[0]
      return docDirectoryPath
    }
    
    override init(){
        super.init()
    
 
    }
    
    func createDatabase(initialQuery: String, baseName: String) -> Bool {
        var created = false
        pathToDatabase = "\(getDocumentDirectoryPath().absoluteString)/\(baseName)"
        if !FileManager.default.fileExists(atPath: pathToDatabase){
            database = FMDatabase(path: pathToDatabase)
            if database != nil {
                if database.open(){

                    do {
                        try database.executeUpdate(initialQuery, values: nil)
                        print("done")
                        created = true
                    }
                    catch {
                        print("could not create table")
                    }
                    database.close()
                    
                    
                }else{
                    print("could not open the database")
                }
            }
        }
        
        return created
    }
    
    func addAlbum(albumTableName: String){
        let createPhotosTable = "create table if not exists \(albumTableName) (photoID integer primary key autoincrement not null, image text)"
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(createPhotosTable, values: nil)
                if result.next(){
                    print("album added")
                
                }
                
            }catch{
                
            }
        }
    }
    
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
     
        if database != nil {
            if database.open() {
                return true
            }
        }
     
        return false
    }
    
    func checkEmptyTable(tableName: String) -> Bool {
        var count = 0
        do {
            let result = try database.executeQuery("select count(*) from \(tableName)", values: nil)
            if result.next(){
                count = Int(result.int(forColumnIndex: 0))
            
            }
            
        }catch{
            
        }
        return count == 0
    }
    

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    
    func insertInitialImages() {
            if openDatabase() {
                if checkEmptyTable(tableName: "所有图片") {
                var query = ""
                for i in 0..<18{
                    let image = UIImage(named: "image\(i)")!
                    let imgString = convertImageToBase64String(img: image)
                    query  = "insert into 所有图片(photoID, image) values (null,'\(imgString)');"
                    
                    do {
                        try database.executeUpdate(query, values: nil)
                    }catch{
                        
                    }
                }
            }
            DBManager.shared.database.close()
                
        }
    }
    
    func getNumOfRows(tableName: String) -> Int {
        
        var rowNum = 0
        if openDatabase() {
            let query = "SELECT COUNT(1) FROM \(tableName);"
            
            do{
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    rowNum = Int(results.int(forColumnIndex: 0))
                    print(rowNum)
                    
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
        
        database.close()
        return rowNum
    }
    
    func getAllTableNames() -> [String] {
        var names = [String]()
        
        if openDatabase() {
            let query = "SELECT name FROM sqlite_master WHERE type='table';"
            
            do{
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let tableName = results.string(forColumn: "name")!
                    if tableName != "sqlite_sequence"{
                        names.append(tableName)
                    }
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
        
        database.close()
        return names
    }
    
    func dropTable(tableName: String){
        if openDatabase() {
            if openDatabase() {
                let query = "drop table \(tableName);"
                
                do{
                    let results = try database.executeQuery(query, values: nil)
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        database.close()
    }
    
    
    func getTheFirstImage(tableName: String) -> UIImage {
        var image = UIImage(named: "placeholder")
        if openDatabase() {
            let query = "select * from \(tableName) limit 1"

            do {
                let results = try database.executeQuery(query, values: nil)


                while results.next() {
                    let imageDataString = results.string(forColumn: "image")
                    let imageData = Data(base64Encoded: imageDataString!)
                    image = UIImage(data: imageData!)!
                                        
                }
                
            }
            catch {
                print(error.localizedDescription)
            }

            database.close()
        }

        return image!
    }
    
    func loadImages(albumName: String) -> [PhotoModel] {
        var images = [PhotoModel]()
        if openDatabase() {
            let query = "select * from \(albumName) order by photoID asc"

            do {
                let results = try database.executeQuery(query, values: nil)
                

                while results.next() {
                    let id = Int(results.int(forColumn: "photoID"))
                    let imageDataString = results.string(forColumn: "image")
                    let imageData = Data(base64Encoded: imageDataString!)
                    let resImage = UIImage(data: imageData!)
                    let imageModel = PhotoModel(photoID: id, image: resImage)
                    images.append(imageModel)
                }
                
                
            }
            catch {
                print(error.localizedDescription)
            }

            database.close()
        }

        return images
    }
    
    
    // add to photo db
    func addImage(imageToAdd: UIImage, albumName: String) {
            if openDatabase() {
                let imgString = convertImageToBase64String(img: imageToAdd)
                let query  = "insert into \(albumName)(photoID, image) values (null,'\(imgString)');"
                
                do {
                    try database.executeUpdate(query, values: nil)
                    print("Added")
                }catch{
                    
                }
            DBManager.shared.database.close()
        }
    }
    
    func deleteImage(id: Int, albumName: String){
    
        if openDatabase(){
            let query = "delete from \(albumName) where photoID = ?"
            do {
                try database.executeUpdate(query, values: [id])
                print("deleted")
            }catch{
                
            }
            
        }
    }
    
    func deleteTable(tableName: String){
        if openDatabase() {
            let query = "drop table \(tableName)"
            database.executeStatements(query)
        }
    }

    
    
    
    
}
