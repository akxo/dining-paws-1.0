//
//  MealsViewController.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/21/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var mealsTable: UITableView!
    
    var selectedDay: Day? = nil
    
    var servingFood: Bool = false
    
    var indexHall: Int? = nil
    
    var indexDay: Int? = nil
    
    @IBOutlet weak var servingLabel: UILabel!
    
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
        
        self.navigationItem.title = getDateNameShort(date: (selectedDay?.date)!)
        let titleAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        if servingFood {
            servingLabel.text = ""
        } else {
            servingLabel.text = "No food is being served"
        }
        
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if servingFood {
            return selectedDay!.meals.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if servingFood {
            return (mealsTable.frame.height - 64) / 7
        } else {
            return mealsTable.frame.height - 64
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if servingFood {
            cell.textLabel?.text = selectedDay?.meals[indexPath.row].name
            return cell
        } else {
            cell.textLabel?.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getOptions(index: indexPath.row)
        performSegue(withIdentifier: "toOptionsView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOptionsView" {
            if let indexPath = mealsTable.indexPathForSelectedRow {
                let destination = segue.destination as! OptionsViewController
                destination.selectedMeal = diningHalls[indexHall!].days[indexDay!].meals[indexPath.row]
            }
        }
    }
    
    func getOptions(index: Int) {
        if diningHalls[indexHall!].days[indexDay!].meals[index].sections.isEmpty {
            if diningHalls[indexHall!].days[indexDay!].meals[index].name.contains("Late") {
                var section = Section(name: "LATE NIGHT")
                let result = diningHalls[indexHall!].days[indexDay!].meals[index].mealData.components(separatedBy: "<div class=\"shortmenurecipes\"><span style=\"color: #000000\">")
                for i in 1...(result.count) - 1 {
                    let option = result[i].components(separatedBy: "</div>")
                    section.options.append(option[0])
                }
                diningHalls[indexHall!].days[indexDay!].meals[index].sections.append(section)
            } else {
                let sections = selectedDay?.meals[index].mealData.components(separatedBy: "<div class=\"shortmenucats\"><span style=\"color: #000000\">-- ")
                for i in 1...(sections?.count)! - 1 {
                    let sectionName = sections?[i].components(separatedBy: " --</span></div>")
                    var section: Section? = nil
                    if (sectionName?[0].contains("--"))! {
                        let name = sectionName?[0].components(separatedBy: "- ")
                        section = Section(name: (name?[1])!)
                    } else {
                        section = Section(name: (sectionName?[0])!)
                    }
                    let options = sections?[i].components(separatedBy: "<div class=\"shortmenurecipes\"><span style=\"color: #000000\">")
                    if (options?.count)! > 1 {
                        for j in 1...(options?.count)! - 1 {
                            let optionName = options?[j].components(separatedBy: "</div>")
                            section?.options.append((optionName?[0])!)
                        }
                        diningHalls[indexHall!].days[indexDay!].meals[index].sections.append((section)!)
                    }
                }
            }
        }
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            navigationController?.popViewController(animated: true)
        }
    }

}
