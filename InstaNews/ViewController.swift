//
//  ViewController.swift
//  InstaNews
//
//  Created by Suniel on 10/10/17.
//  Copyright © 2017 Suniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theWebView: UIWebView!
    
    var urlString: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let niceUrl = URL(string: urlString)
        
        print("The URL String is: \(urlString)")
        print("The Web URl: \(String(describing: niceUrl))")
        
        if let theFinalUrl = niceUrl{
            
            print("Final URL: \(theFinalUrl)")
            print("Now load the whole Internet")
            theWebView.loadRequest(URLRequest(url: theFinalUrl))
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

