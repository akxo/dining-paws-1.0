//
//  Data.swift
//  Dining Paws
//
//  Created by Alexander Kerendian on 8/18/17.
//  Copyright © 2017 Aktrapp. All rights reserved.
//

import Foundation

struct DiningHall {
    let name: String
    let locationName: String
    let locationNum: String
    var days: [Day]
    
    init(name: String, locationName: String, locationNum: String) {
        self.name = name
        self.locationName = locationName
        self.locationNum = locationNum
        self.days = []
    }
}

struct Day {
    let date: Date
    let menuData: String
    var meals: [Meal]
    
    init(date: Date, menuData: String) {
        self.date = date
        self.menuData = menuData
        self.meals = []
    }
}

struct Meal {
    let name: String
    let mealData: String
    var options: [String]
    var sections: [Section]
    
    init(name: String, mealData: String) {
        self.name = name
        self.mealData = mealData
        self.options = []
        self.sections = []
        
    }
}

struct Section {
    let name: String
    var options: [String]
    
    init(name: String) {
        self.name = name
        self.options = []
    }
    
}

struct SearchElement {
    let option: String
    let diningHall: DiningHall
    let day: Day
    let meal: Meal
    
    init(option: String, diningHall: DiningHall, day: Day, meal: Meal) {
        self.option = option
        self.diningHall = diningHall
        self.day = day
        self.meal = meal
    }
    
}

let data = UserDefaults.standard
let diningHallNames = ["Buckley", "Towers", "McMahon", "North", "Northwest", "Putnam", "South", "Whitney"]
var diningHalls = [DiningHall]()
var searchElements: [SearchElement] = []
var week = [Date]()
var ogWeek: [Date] = []
var indexDay: Int? = nil


func buildDiningHalls() {
    
    var tempName: String = ""
    var tempLocName: String = ""
    var tempLocNum: String = ""
    
    tempName = "Buckley"
    tempLocName = "Buckley+Dining+Hall"
    tempLocNum = "03"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))

    tempName = "Towers"
    tempLocName = "Gelfenbien+Commons+%26+Halal"
    tempLocNum = "42"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))

    tempName = "McMahon"
    tempLocName = "McMahon+Dining+Hall"
    tempLocNum = "05"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
    
    tempName = "North"
    tempLocName = "North+Campus+Dining+Hall"
    tempLocNum = "07"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
    
    tempName = "Northwest"
    tempLocName = "Northwest+Marketplace"
    tempLocNum = "15"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
    
    tempName = "Putnam"
    tempLocName = "Putnam+Dining+Hall"
    tempLocNum = "06"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
        
    tempName = "South"
    tempLocName = "South+Campus+Marketplace"
    tempLocNum = "16"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
        
    tempName = "Whitney"
    tempLocName = "Whitney+Dining+Hall"
    tempLocNum = "01"
    diningHalls.append(DiningHall(name: tempName, locationName: tempLocName, locationNum: tempLocNum))
}

func buildWeek() {
    let today = Date()
    week.append(today)
    for i in 1...6 {
        week.append(Calendar.current.date(byAdding: .day, value: i, to: today)!)
    }
}

func buildOGWeek() {
    let date = data.object(forKey: "storedDate") as! Date
    ogWeek.append(date)
    for i in 1...6 {
        ogWeek.append(Calendar.current.date(byAdding: .day, value: i, to: date)!)
    }
}

func buildSearchElements(search: String) {
    var tempSearchElements: [SearchElement] = []
    for i in 0...7 {
        for j in 0...6 {
            getMeals(indexdhall: i, indexDay: j)
            if diningHalls[i].days[j].meals.count == 0 {
            } else {
                for k in 0...diningHalls[i].days[j].meals.count - 1 {
                    getOptions(indexdhall: i, indexDay: j, indexMeal: k)
                    for l in 0...diningHalls[i].days[j].meals[k].options.count - 1 {
                        let option = diningHalls[i].days[j].meals[k].options[l]
                        if option.lowercased().contains(search) {
                            let dhall = diningHalls[i]
                            let day = diningHalls[i].days[j]
                            let meal = diningHalls[i].days[j].meals[k]
                            tempSearchElements.append(SearchElement(option: option, diningHall: dhall, day: day, meal: meal))
                        }
                    }
                }

            }
        }
    }
    searchElements = tempSearchElements
}

func compareDates(date1: Date, date2: Date) -> Bool {
    let year1 = Calendar.current.component(.year, from: date1)
    let month1 = Calendar.current.component(.month, from: date1)
    let day1 = Calendar.current.component(.day, from: date1)
    
    let year2 = Calendar.current.component(.year, from: date2)
    let month2 = Calendar.current.component(.month, from: date2)
    let day2 = Calendar.current.component(.day, from: date2)
    
    if year1 != year2 || month1 != month2 || day1 != day2 {
        return false
    } else {
        return true
    }
}

// not today! use stored date?

func fallsWithinWeek() -> Bool {
    let today = week[0]
    for i in 0...ogWeek.count - 1 {
        if compareDates(date1: today, date2: ogWeek[i]) {
            indexDay = i
            return true
        }
    }
    return false
}

func createLink(dhall: DiningHall, date: Date) -> String {
    var link = "http://nutritionanalysis.dds.uconn.edu/shortmenu.asp?sName=UCONN+Dining+Services&locationNum=" + dhall.locationNum + "&locationName=" + dhall.locationName + "&naFlag=1"
    let today = Date()
    if compareDates(date1: date, date2: today) == false {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        link = link + "&WeeksMenus=This+Week%27s+Menus&myaction=read&dtdate=\(month)%2F\(day)%2F\(year)"
    }
    return link
}

func getMenuData() -> Bool {
    for i in 0...diningHalls.count - 1 {
        var menuData: [String] = []
        for date in week {
            let link = createLink(dhall: diningHalls[i], date: date)
            guard let url = URL(string: link) else {
                print("Error: \(link) doesn't seem to be a valid URL")
                return false
            }
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                menuData.append(html)
                let day = Day(date: date, menuData: html)
                diningHalls[i].days.append(day)
            } catch let error {
                print("Error: \(error)")
                return false
            }
        }
        data.set(menuData, forKey: diningHalls[i].name)
    }
    data.set(true, forKey: "hasData")
    data.set(Date(), forKey: "storedDate")
    return true
}

func getPartialMenuData() -> Bool {
    for i in 0...diningHalls.count - 1 {
        let loadedMenuData = data.stringArray(forKey: diningHalls[i].name)!
        var tempMenuData: [String] = []
        for j in indexDay!...ogWeek.count - 1 {
            tempMenuData.append(loadedMenuData[j])
            let day = Day(date: ogWeek[j], menuData: loadedMenuData[j])
            diningHalls[i].days.append(day)
        }
        data.set(tempMenuData, forKey: diningHalls[i].name)
    }
    for i in 0...diningHalls.count - 1 {
        var menuData: [String] = data.stringArray(forKey: diningHalls[i].name)!
        for j in (week.count - indexDay!)...week.count - 1 {
            let link = createLink(dhall: diningHalls[i], date: week[j])
            guard let url = URL(string: link) else {
                print("Error: \(link) doesn't seem to be a valid URL")
                return false
            }
            do {
                let html = try String(contentsOf: url, encoding: .ascii)
                menuData.append(html)
                let day = Day(date: week[j], menuData: html)
                diningHalls[i].days.append(day)
            } catch let error {
                print("Error: \(error)")
                return false
            }
        }
        data.set(menuData, forKey: diningHalls[i].name)
    }
    data.set(true, forKey: "hasData")
    data.set(Date(), forKey: "storedDate")
    return true
}

func loadMenuData() {
    outer: for i in 0...diningHalls.count - 1 {
        let menuData = data.stringArray(forKey: diningHalls[i].name)!
        if week.count == menuData.count {
            for j in 0...week.count - 1 {
                let day = Day(date: week[j], menuData: menuData[j])
                diningHalls[i].days.append(day)
            }
        } else {
            _ = getMenuData()
            break outer
        }
    }
}

func getDateName(date: Date) -> String {
    if compareDates(date1: date, date2: Date()) {
        return "Today"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let name = dateFormatter.string(from: date)
        return name
    }
}

func getDateNameShort(date: Date) -> String {
    if compareDates(date1: date, date2: Date()) {
        return "Today"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE. MMMM d"
        let name = dateFormatter.string(from: date)
        return name
    }
}

func getSearchElementDetails(searchElement: SearchElement) -> String {
    let details = searchElement.diningHall.name + " -> " + getDateNameShort(date: searchElement.day.date) + " -> " + searchElement.meal.name
    return details
}

func resetDefaults() {
    let defaults = data
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
    defaults.synchronize()
}




func getMeals(indexdhall: Int, indexDay: Int) {
    
    if diningHalls[indexdhall].days[indexDay].meals.isEmpty {
        let result = diningHalls[indexdhall].days[indexDay].menuData.components(separatedBy: "<div class=\"shortmenumeals\">")
        if (result.count) > 1 {
            for i in 1...(result.count) - 1 {
                if (result[i].hasPrefix("Breakfast")) {
                    let meal = Meal(name: "Breakfast", mealData: (result[i]))
                    diningHalls[indexdhall].days[indexDay].meals.append(meal)
                }
                else if (result[i].hasPrefix("Brunch")) {
                    let meal = Meal(name: "Brunch", mealData: (result[i]))
                    diningHalls[indexdhall].days[indexDay].meals.append(meal)
                }
                else if (result[i].hasPrefix("Lunch")) {
                    let meal = Meal(name: "Lunch", mealData: (result[i]))
                    diningHalls[indexdhall].days[indexDay].meals.append(meal)
                }
                else if (result[i].hasPrefix("Dinner")) {
                    var lnMealData = ""
                    var mealData = result[i]
                    if diningHalls[indexdhall].name.contains("McMahon") || diningHalls[indexdhall].name.contains("Putnam") || diningHalls[indexdhall].name.contains("Northwest") || diningHalls[indexdhall].name.contains("Whitney") {
                        if (result[i].contains("LATE NIGHT")) {
                            let lnResult = result[i].components(separatedBy: "LATE NIGHT")
                            let lnRawData = lnResult[1].components(separatedBy: "<div class=\"shortmenucats\"><span style=\"color: #000000\">")
                            lnMealData = (lnRawData[0])
                            mealData = lnResult[0]
                            if (lnRawData.count) > 1 {
                                for i in 1...(lnRawData.count) - 1 {
                                    mealData = mealData + (lnRawData[i])
                                }
                            }
                        }
                    }
                    let meal = Meal(name: "Dinner", mealData: mealData)
                    diningHalls[indexdhall].days[indexDay].meals.append(meal)
                    if lnMealData != "" {
                        let lnMeal = Meal(name: "Late Night", mealData: lnMealData)
                        diningHalls[indexdhall].days[indexDay].meals.append(lnMeal)
                    }
                }
            }
        }
    }
}
    


func getOptions(indexdhall: Int, indexDay: Int, indexMeal: Int) {
    if diningHalls[indexdhall].days[indexDay].meals[indexMeal].options.isEmpty {
        let result = diningHalls[indexdhall].days[indexDay].meals[indexMeal].mealData.components(separatedBy: "<div class=\"shortmenurecipes\"><span style=\"color: #000000\">")
        for i in 1...(result.count) - 1 {
            let option = result[i].components(separatedBy: "</div>")
            diningHalls[indexdhall].days[indexDay].meals[indexMeal].options.append((option[0]))
        }
    }
}







