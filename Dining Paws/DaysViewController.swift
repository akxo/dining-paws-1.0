//
//  DaysViewController.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/20/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DaysViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var daysTable: UITableView!
    
    var servingFood: Bool = false
    
    var indexdhall: Int? = nil
    
    var selectedDiningHall: DiningHall? = nil
    
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
        
        self.navigationItem.title = selectedDiningHall?.name
        let titleAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes

        
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        daysTable.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedDiningHall?.days.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (daysTable.frame.height - 64) / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = getDateName(date: (selectedDiningHall?.days[indexPath.row].date)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        servingFood = getMeals(index: indexPath.row)
        
        performSegue(withIdentifier: "toMealsView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealsView" {
            if let indexPath = daysTable.indexPathForSelectedRow {
                let destination = segue.destination as! MealsViewController
                destination.selectedDay = (diningHalls[indexdhall!].days[indexPath.row])
                destination.indexHall = self.indexdhall
                destination.indexDay = indexPath.row
                destination.servingFood = servingFood
            }
        }
    }
    
    func getMeals(index: Int) -> Bool {

        if diningHalls[indexdhall!].days[index].meals.isEmpty {
            let result = selectedDiningHall?.days[index].menuData.components(separatedBy: "<div class=\"shortmenumeals\">")
            if (result?.count)! > 1 {
                for i in 1...(result?.count)! - 1 {
                    if (result?[i].hasPrefix("Breakfast"))! {
                        let meal = Meal(name: "Breakfast", mealData: (result?[i])!)
                        diningHalls[indexdhall!].days[index].meals.append(meal)
                    }
                    else if (result?[i].hasPrefix("Brunch"))! {
                        let meal = Meal(name: "Brunch", mealData: (result?[i])!)
                        diningHalls[indexdhall!].days[index].meals.append(meal)
                    }
                    else if (result?[i].hasPrefix("Lunch"))! {
                        let meal = Meal(name: "Lunch", mealData: (result?[i])!)
                        diningHalls[indexdhall!].days[index].meals.append(meal)
                    }
                    else if (result?[i].hasPrefix("Dinner"))! {
                        var lnMealData = ""
                        var mealData = result?[i]
                        if diningHalls[indexdhall!].name.contains("McMahon") || diningHalls[indexdhall!].name.contains("Putnam") || diningHalls[indexdhall!].name.contains("Northwest") || diningHalls[indexdhall!].name.contains("Whitney") {
                            if (result?[i].contains("LATE NIGHT"))! {
                                let lnResult = result?[i].components(separatedBy: "LATE NIGHT")
                                let lnRawData = lnResult?[1].components(separatedBy: "<div class=\"shortmenucats\"><span style=\"color: #000000\">")
                                lnMealData = (lnRawData?[0])!
                                mealData = lnResult?[0]
                                if (lnRawData?.count)! > 1 {
                                    for i in 1...(lnRawData?.count)! - 1 {
                                        mealData = mealData! + (lnRawData?[i])!
                                    }
                                }
                            }
                        }
                        let meal = Meal(name: "Dinner", mealData: mealData!)
                        diningHalls[indexdhall!].days[index].meals.append(meal)
                        if lnMealData != "" {
                            let lnMeal = Meal(name: "Late Night", mealData: lnMealData)
                            diningHalls[indexdhall!].days[index].meals.append(lnMeal)
                        }
                    }
                }
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            navigationController?.popViewController(animated: true)
        }
    }

    
}
