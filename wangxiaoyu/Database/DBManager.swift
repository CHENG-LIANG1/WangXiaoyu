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
    let databaseFileName = "movies.sqlite"
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
                
                if checkEmptyTable(tableName: "photoTB") {
                
                var query = ""
                for i in 0..<18{
                    let image = UIImage(named: "image\(i)")!
                    let imgString = convertImageToBase64String(img: image)
                    query  = "insert into photoTB(photoID, image) values (null,'\(imgString)');"
                    
                    do {
                        try database.executeUpdate(query, values: nil)
                    }catch{
                        
                    }
                }
            }
            DBManager.shared.database.close()
                
        }
    }
    
    
    func loadImages() -> [PhotoModel] {
        var images = [PhotoModel]()
        if openDatabase() {
            let query = "select * from photoTB order by photoID asc"

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
    func addImage(imageToAdd: UIImage) {
            if openDatabase() {
                let imgString = convertImageToBase64String(img: imageToAdd)
                let query  = "insert into photoTB(photoID, image) values (null,'\(imgString)');"
                
                do {
                    try database.executeUpdate(query, values: nil)
                    print("Added")
                }catch{
                    
                }
            DBManager.shared.database.close()
        }
    }
    
    func deleteImage(id: Int){
    
        if openDatabase(){
            let query = "delete from photoTB where photoID = ?"
            do {
                try database.executeUpdate(query, values: [id])
                print("deleted")
            }catch{
                
            }
            
        }
    }

    
    
    
    
}
