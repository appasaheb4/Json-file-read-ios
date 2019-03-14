//
//  ViewController.swift
//  JsonFileRead
//
//  Created by developer on 8/15/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var tblAttachmentFiles: UITableView!
    
    
    
    var arrJsonList = NSArray()
    var attendanceList = NSDictionary() //[String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readJson()
        self.decoration()
    }
    
    func decoration(){
        self.tblAttachmentFiles.register(UINib(nibName: "AttachmentFilesTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentFilesTableViewCell")
        
    }
    
    
    private func readJson() {
        do {
            if let file =  Bundle.main.url(forResource: "JsonFirstFile", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    print("json data =",object)
                    arrJsonList = (json as! NSDictionary).value(forKey: "jsonRead") as! NSArray
                } else if let object = json as? [Any] {
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        self.showData()
    }
    
    func showData(){
        attendanceList = self.arrJsonList[0] as! NSDictionary //[String:Any]
        self.lblTitle.text = attendanceList["title"] as! String!
        self.lblSummary.text =  attendanceList["Summary"] as! String!
    }
    
    

}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         attendanceList = self.arrJsonList[0] as!  NSDictionary//[String:Any]
         let attachment = attendanceList["attatchmentFiles"] as! NSArray
        return attachment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = self.tblAttachmentFiles.dequeueReusableCell(withIdentifier: "AttachmentFilesTableViewCell") as! AttachmentFilesTableViewCell
        let attendanceList = self.attendanceList["attatchmentFiles"]  as! NSArray
        let singleAttendanceList =  attendanceList[indexPath.row] as! NSDictionary//[String:Any]
         let filename: NSString = singleAttendanceList["atta"] as! NSString
        let pathExtention = filename.pathExtension
        if(pathExtention == "pdf"){
            cell.imgRef.image = #imageLiteral(resourceName: "pdffile")
        }
        else if(pathExtention == "ppt"){
            
            cell.imgRef.image = #imageLiteral(resourceName: "pptfile")
            
        }
        cell.lblFileName.text = NSURL(fileURLWithPath: (singleAttendanceList["atta"] as? String)!).lastPathComponent!
            return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

