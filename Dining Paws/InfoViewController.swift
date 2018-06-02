//
//  InfoViewController.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/28/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InfoViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!

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
        
        self.navigationItem.title = "Normal Hours"
        let titleAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        
        // Do any additional setup after loading the view.
        
        
        if view.frame.height > 720 {
            hoursLabel.font = UIFont(name: "Helvetica", size: 16.0)
            hoursLabel.text = "MONDAY - FRIDAY\n\nBreakfast: 7:00am – 10:45am\n\nLunch: 11:00am – 2:15pm\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Mon. – Fri. 2:15pm - 3:45pm)\n\nDinner: 4:15pm – 7:15pm\n\nOpen late: Whitney, McMahon & Northwest\n(open until 10pm Sunday – Thursday)\n\n\n\nSATURDAY & SUNDAY\n\nBreakfast served only at South\nSaturday: 7:00am – 9:30am\nSunday: 8:00am – 9:30am\n\nBrunch at all dining units 10:30am – 2:15pm\n(except South & Towers: Brunch 9:30am – 2:15pm)\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Sat. & Sun. 2:15pm - 3:45pm)\n\nDinner: 4:30pm – 7:15pm"
        } else if view.frame.height > 645 {
            hoursLabel.font = UIFont(name: "Helvetica", size: 14.0)
            hoursLabel.text = "MONDAY - FRIDAY\n\nBreakfast: 7:00am – 10:45am\n\nLunch: 11:00am – 2:15pm\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Mon. – Fri. 2:15pm - 3:45pm)\n\nDinner: 4:15pm – 7:15pm\n\nOpen late: Whitney, McMahon & Northwest\n(open until 10pm Sunday – Thursday)\n\n\n\n\nSATURDAY & SUNDAY\n\nBreakfast served only at South\nSaturday: 7:00am – 9:30am\nSunday: 8:00am – 9:30am\n\nBrunch at all dining units 10:30am – 2:15pm\n(except South & Towers: Brunch 9:30am – 2:15pm)\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Sat. & Sun. 2:15pm - 3:45pm)\n\nDinner: 4:30pm – 7:15pm"
        } else if view.frame.height > 545 {
            hoursLabel.text = "MONDAY - FRIDAY\n\nBreakfast: 7:00am – 10:45am\n\nLunch: 11:00am – 2:15pm\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Mon. – Fri. 2:15pm - 3:45pm)\n\nDinner: 4:15pm – 7:15pm\n\nOpen late: Whitney, McMahon & Northwest\n(open until 10pm Sunday – Thursday)\n\nSATURDAY & SUNDAY\n\nBreakfast served only at South\nSaturday: 7:00am – 9:30am\nSunday: 8:00am – 9:30am\n\nBrunch at all dining units 10:30am – 2:15pm\n(except South & Towers: Brunch 9:30am – 2:15pm)\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Sat. & Sun. 2:15pm - 3:45pm)\n\nDinner: 4:30pm – 7:15pm"
        } else {
            hoursLabel.text = "MONDAY - FRIDAY\nBreakfast: 7:00am – 10:45am\nLunch: 11:00am – 2:15pm\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Mon. – Fri. 2:15pm - 3:45pm)\nDinner: 4:15pm – 7:15pm\n\nOpen late: Whitney, McMahon & Northwest\n(open until 10pm Sunday – Thursday)\n\nSATURDAY & SUNDAY\nBreakfast served only at South\nSaturday: 7:00am – 9:30am\nSunday: 8:00am – 9:30am\n\nBrunch at all dining units 10:30am – 2:15pm\n(except South & Towers: Brunch 9:30am – 2:15pm)\n\nBetween Meals: 2:15pm – 4:15pm\n(McMahon closes Sat. & Sun. 2:15pm - 3:45pm)\n\nDinner: 4:30pm – 7:15pm"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            navigationController?.popViewController(animated: true)
        }
    }


}
