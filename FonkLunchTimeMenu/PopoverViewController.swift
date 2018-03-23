//
//  PopoverViewController.swift
//  FonkLunchTimeMenu
//
//  Created by Wilco Wilkens on 2018/03/20.
//  Copyright © 2018 Appulse. All rights reserved.
//

import UIKit
import SDWebImage

class PopoverViewController: UIViewController {

    @IBOutlet weak var FoodPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    var foodImage = ""
    var foodName = ""
    var foodDescription = ""
    var day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FoodPic.sd_setImage(with: URL(string: foodImage), placeholderImage: UIImage())
        
        name.text = foodName
        descriptionView.text = foodDescription
        dayLabel.text = day
        
        descriptionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.descriptionView?.scrollRangeToVisible(NSRange(location: 0,length: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPopoverButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
