//
//  ArticleListViewController.swift
//  InstaNews
//
//  Created by Suniel on 10/10/17.
//  Copyright © 2017 Suniel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Social

private let apiKey = "eb0afc9c1f884880bf368c464d8dab82"
private let cellReuse = "ArticleCell"
private let nextSB = "singleArticleSB"

//var apiUrlSource = "the-verge"

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var apiUrl = "https://newsapi.org/v1/articles?source=the-verge&sortBy=latest&apiKey=eb0afc9c1f884880bf368c464d8dab82"
    
    var ArticleData = [[String:Any]]()
    
    lazy var pullRefresh: UIRefreshControl = {
        let pullRefresh = UIRefreshControl()
        //pullRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullRefresh.addTarget(self, action: #selector(ArticleListViewController.fetchApi), for: UIControlEvents.valueChanged)
        return pullRefresh
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.addSubview(self.pullRefresh)
        
        fetchApi()

    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        let alertView = UIAlertController(title: "Share", message: "Share this Article", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                post.setInitialText("Article")
                post.add(UIImage(named: "homestead-dawn-background"))
                self.present(post, animated: true, completion: nil)
            } else{
                print("Facebook not connected.")
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ArticleListViewController{
    
    @objc func fetchApi() {
        
        Alamofire.request(apiUrl).responseJSON{ response in
            
            if let jsonResponse = response.result.value{
                
                let json = JSON(jsonResponse)
                let articlesData = json["articles"].arrayObject
                self.ArticleData = articlesData as! [[String : Any]]
                
            }
            
            self.indicator.stopAnimating()
            self.pullRefresh.endRefreshing()
            
            self.tableView.reloadData()
            
            print("Article Data: \(self.ArticleData)")
            
        }
        
    }
    
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuse) as! ArticleViewCell
        
        cell.articleImage.sd_setImage(with: URL(string: ArticleData[indexPath.row]["urlToImage"] as! String), placeholderImage: UIImage(named: "sirikit-featured"), options: [.progressiveDownload, .continueInBackground])
        cell.articleTitle.text = ArticleData[indexPath.row]["title"] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = ArticleData[indexPath.row]
        
        if let singleVc = self.storyboard?.instantiateViewController(withIdentifier: nextSB) as? ViewController {
            
            singleVc.urlString = ArticleData[indexPath.row]["url"] as! String
            
            let add = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
            //let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playTapped))
            
            self.navigationController?.pushViewController(singleVc, animated: true)
            singleVc.navigationItem.title = (article["title"] as! String)
            
            singleVc.navigationItem.rightBarButtonItems = [add]
        
        }
        
    }
    
}

