//
//  OptionsViewController.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/22/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var optionsTable: UITableView!
    
    var selectedMeal: Meal? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        bannerView.adUnitID = "ca-app-pub-7933787916135393/7407307572"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(request)
        
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0.5019607843, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.navigationItem.title = selectedMeal?.name
        let titleAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (selectedMeal?.sections.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedMeal?.sections[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedMeal?.sections[section].options.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = selectedMeal?.sections[indexPath.section].options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            navigationController?.popViewController(animated: true)
        }
    }

}
