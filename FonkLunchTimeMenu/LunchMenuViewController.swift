//
//  LunchMenuViewController.swift
//  FonkLunchTimeMenu
//
//  Created by Wilco Wilkens on 2018/03/20.
//  Copyright © 2018 Appulse. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class LunchMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    let ref = Database.database().reference()
    
    @IBOutlet weak var menuTable: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var spinner = UIActivityIndicatorView()
    
    var lunchDictionary = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.frame = CGRect(x: 0,y:0,width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        spinner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        spinner.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:
            #selector(LunchMenuViewController.refresh(_:)),
                                 for: UIControlEvents.valueChanged)
        menuTable.addSubview(refreshControl)
        
        getLunchMenu()
    }
    
    //pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl)
    {
        lunchDictionary.removeAll(keepingCapacity: true)
        getLunchMenu()
    }
    
    func getLunchMenu()
    {
        ref.child("Lunch Menu").observeSingleEvent(of: .value) { (snap) in
            
            for day in snap.children
            {
                let dayInfo = (day as! DataSnapshot).value as! NSMutableDictionary
                
                if dayInfo["description"] == nil
                {
                    dayInfo["description"] = ""
                }
                
                if dayInfo["imageUrl"] == nil
                {
                    dayInfo["imageUrl"] = ""
                }
                
                if dayInfo["name"] == nil
                {
                    dayInfo["name"] = ""
                }
                
                var dayNr = (day as! DataSnapshot).key
                dayNr.remove(at: dayNr.startIndex)
                dayInfo["day"] = dayNr
                
                self.lunchDictionary.append(dayInfo)
            }
            
            self.refreshControl.endRefreshing()
            self.spinner.stopAnimating()
            self.menuTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lunchDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lunchCell", for: indexPath) as! LunchTableViewCell
        
        if lunchDictionary.count > indexPath.row
        {
        cell.lunchDay.text = (lunchDictionary[indexPath.row]["day"] as? String)
        cell.lunchName.text = lunchDictionary[indexPath.row]["name"] as? String
        
        let imageUrl = URL(string:lunchDictionary[indexPath.row]["imageUrl"] as! String)
        cell.lunchImage.sd_setImage(with: imageUrl, placeholderImage: UIImage())
        }
        cell.lunchImage.layer.cornerRadius = 10
        cell.lunchImage.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }
    
    var selectedDay = NSDictionary()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDay = lunchDictionary[indexPath.row]
        performSegue(withIdentifier: "popover", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "popover"
        {
            let PopoverViewController = segue.destination as! PopoverViewController
            PopoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            
        PopoverViewController.preferredContentSize = CGSize(width:UIScreen.main.bounds.width - 40, height:UIScreen.main.bounds.height - 80)
        
            PopoverViewController.popoverPresentationController?.sourceRect = CGRect(x:0,y:20,width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height - 80)//UIScreen.main.bounds
            
        PopoverViewController.popoverPresentationController!.delegate = self
            
            //set variables for popover
            PopoverViewController.foodName = selectedDay["name"] as! String
            PopoverViewController.foodDescription = selectedDay["description"] as! String
            PopoverViewController.day = selectedDay["day"] as! String
            PopoverViewController.foodImage = selectedDay["imageUrl"] as! String
        }
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
