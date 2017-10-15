//
//  NewsSourceViewController.swift
//  InstaNews
//
//  Created by Suniel on 10/12/17.
//  Copyright © 2017 Suniel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

private let sourceApiCall = "https://newsapi.org/v1/sources?language=en"
private let sourceCellId = "sourceCell"
private let ArticleSB = "ArticleListSB"

func manageObjectContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manageObjectContext = appDelegate.persistentContainer.viewContext
    return manageObjectContext
}

class NewsSourceViewController: UIViewController { 
    
    @IBOutlet weak var sourceTableView: UITableView!
    @IBOutlet weak var sourceIndicator: UIActivityIndicatorView!
    
    var tempData = ["Hello", "Bello", "Jello", "Mellow", "Floro"]
    var sourcesData = [[String : Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.sourceIndicator.hidesWhenStopped = true
        self.sourceIndicator.startAnimating()
        
        self.sourceTableView.delegate = self
        self.sourceTableView.dataSource = self
        
        self.navigationItem.title = "InstaNews"
        
        fetchSourceApi()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewsSourceViewController{
    
    // Fetch Source API
    func fetchSourceApi() {
        
        Alamofire.request(sourceApiCall).validate().responseJSON{ response in
            switch response.result {
            case let .success(value):
                
                let json = JSON(value)
                let sourceJson = json["sources"].arrayObject
                self.sourcesData = sourceJson as! [[String : Any]]
                self.saveToCoreData()
                break
            case let .failure(error):
                
                let alert = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .actionSheet)
                let alertAction = UIAlertAction(title: "Ok. I will try again", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                
                break
            }
            self.sourceTableView.reloadData()
            self.sourceIndicator.stopAnimating()
            
            //print("Article Data: \(self.sourcesData)")
            
        }
        
    }
    
}

extension NewsSourceViewController {

    func saveToCoreData() {

        for newsSource in self.sourcesData {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Source", in: manageObjectContext())
            let managedObject = NSManagedObject(entity: entityDescription!, insertInto: manageObjectContext()) as! Source
            
            managedObject.title = newsSource["name"] as? String
            managedObject.category = newsSource["category"] as? String
            managedObject.image = NSData()
            
            
            do {
                try manageObjectContext().save()
                print("saved")
            }catch
            {
                print("unable to save to core data")
                abort()
            }
        }

    }
    
    func fetchAndReload() {
        
        // TODO: Now fetch the data from Core Data
        
    }
    
}

extension NewsSourceViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tempSources = sourcesData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sourceCellId)
        cell?.textLabel?.text = tempSources["name"] as? String
        cell?.detailTextLabel?.text = tempSources["category"] as? String
        
        let sourceImageUrl = tempSources["url"] as? String
        
        cell?.imageView?.sd_setImage(with: URL(string: "https://icons.better-idea.org/icon?url="+sourceImageUrl!+"&size=70..120..200"), placeholderImage: UIImage(named: "homestead-dawn-background"), options: [.progressiveDownload, .continueInBackground])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let articleVcSource = sourcesData[indexPath.row]
        
        if let articleVc = self.storyboard?.instantiateViewController(withIdentifier: ArticleSB) as? ArticleListViewController{
            
            let articleVcApiSource = articleVcSource["id"] as! String
            
            let articleVcApiUrl = "https://newsapi.org/v1/articles?source="+articleVcApiSource+"&apiKey=eb0afc9c1f884880bf368c464d8dab82"
            
            articleVc.apiUrl = articleVcApiUrl
            
            print("Article Api Link: \(articleVcApiUrl)")
            
            self.navigationController?.pushViewController(articleVc, animated: true)
            
            articleVc.navigationItem.title = (articleVcSource["name"] as! String)
            
            print("Go the other way.")
            
        }
    
    }
    
    
    
}
