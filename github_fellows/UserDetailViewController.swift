//
//  UserDetailViewController.swift
//  github_fellows
//
//  Created by nacnud on 1/25/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {


    @IBOutlet weak var userImageView: UIImageView!
    
    var presentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = presentUser {
            self.userImageView.image = user.avatarImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
