//
//  DiningHallsViewController.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/18/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DiningHallsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var diningHallsTable: UITableView!
    
    var hasLoaded: Bool = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var networkConnection = false
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        bannerView.adUnitID = "ca-app-pub-7933787916135393/7407307572"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(request)
        
        // Create the info button
        let infoButton = UIButton(type: .infoLight)
        
        // You will need to configure the target action for the button itself, not the bar button itemr
        infoButton.addTarget(self, action: #selector(getInfoAction), for: .touchUpInside)
        
        // Create a bar button item using the info button as its custom view
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        // Use it as required
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
        loadingLabel.text = "Loading all dining hall menus..."
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0.5019607843, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let titleAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 25)!, NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        diningHallsTable.tableHeaderView = searchController.searchBar

        
        
        if data.object(forKey: "hasData") == nil {
            data.set(false, forKey: "hasData")
        }
        activityIndicator.center = self.diningHallsTable.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        diningHallsTable.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        //resetDefaults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if hasLoaded == false {
            UIApplication.shared.beginIgnoringInteractionEvents()
            buildDiningHalls()
            buildWeek()
            if data.object(forKey: "storedDate") != nil {
                buildOGWeek()
                if data.bool(forKey: "hasData") && compareDates(date1: Date(), date2: data.object(forKey: "storedDate") as! Date) {
                    loadMenuData()
                    self.networkConnection = true
                } else if data.bool(forKey: "hasData") && fallsWithinWeek() {
                    self.networkConnection = getPartialMenuData()
                } else {
                    self.networkConnection = getMenuData()
                }
            } else {
                self.networkConnection = getMenuData()
            }
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if networkConnection {
                hasLoaded = true
                loadingLabel.text = ""
            } else {
                loadingLabel.text = "Check network connection."
            }
            diningHallsTable.reloadData()
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasLoaded == false || networkConnection == false {
            return 8
        } else if isSearching {
            return searchElements.count
        } else {
            return diningHalls.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (diningHallsTable.frame.height - 92) / 8

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasLoaded == false || networkConnection == false {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = ""
            return cell
            
        } else if isSearching {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = searchElements[indexPath.row].option
            cell.detailTextLabel?.text = getSearchElementDetails(searchElement: searchElements[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = diningHalls[indexPath.row].name
            cell.detailTextLabel?.textColor = UIColor.gray
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(isSearching) {
            performSegue(withIdentifier: "toDaysView", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDaysView" {
            if let indexPath = diningHallsTable.indexPathForSelectedRow {
                let destination = segue.destination as! DaysViewController
                destination.selectedDiningHall = diningHalls[indexPath.row]
                destination.indexdhall = indexPath.row
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == "" {
            isSearching = false
            searchElements = []
        } else {
            isSearching = true
            buildSearchElements(search: (searchController.searchBar.text?.lowercased())!)
        }
        diningHallsTable.reloadData()
    }
    
    func getInfoAction() {
        performSegue(withIdentifier: "toInfoView", sender: self)
    }

}
