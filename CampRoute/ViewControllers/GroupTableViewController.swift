//
//  GroupTableViewController.swift
//  CampRoute
//
//  Created by Donald King on 30/08/2020.
//  Copyright © 2020 Donald King. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    var groupArray = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonToData()
        findTheRoute()
        setWaitingTime()
        self.tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        
        cell.groupLabel.text = "Group \(groupArray[indexPath.row].familyid)"
        cell.groupSizeLabel.text = "Group size: \(groupArray[indexPath.row].nPeople)"
        cell.destinationNumberLabel.text = "Destination Caravan: \(groupArray[indexPath.row].destinationCaravanNumber)"
        cell.travelTimeLabel.text = "Travel time: \(groupArray[indexPath.row].travelTime)"
        cell.waitingTimeLabel.text = "Waiting time: \(groupArray[indexPath.row].waitingTime)"
        cell.routeLabel.text = groupArray[indexPath.row].route

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
    
    func jsonToData(){
        
        if let path = Bundle.main.path(forResource: "problem_path_data", ofType: "json") {
            
            let jsonArray = try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: path)), options: JSONSerialization.ReadingOptions()) as? [[String:Int]]
            
            for x in 0..<jsonArray!.count{
                let element = jsonArray![x]
                groupArray.append(Group(familyid: element["familyid"]!, nPeople: element["groupsize"]!, destinationCaravanNumber: element["caravan"]!, travelTime: 0, waitingTime: 0, route: ""))
            }
            
        }
        
    }
    
    func findTheRoute(){
        
        for x in 0..<groupArray.count{
            
            var destinationN = groupArray[x].destinationCaravanNumber
            
            if destinationN >= 1 && destinationN <= 7{
                groupArray[x].travelTime = destinationN
                
                var stringRoute = "0-"
                for i in 1..<destinationN+1{
                    stringRoute += "\(i)-"
                }
                stringRoute.removeLast()
                groupArray[x].route = stringRoute
            }else if (destinationN >= 14 && destinationN <= 16) || destinationN == 8{
                if destinationN == 8 { destinationN = 13 }
                
                groupArray[x].travelTime = 2 + (17-destinationN)
                
                var stringRoute = "0-1-13-"
                for i in 1..<(17-destinationN)+1{
                    var difference = 17-i
                    if difference == 13 { difference = 8 }
                    stringRoute += "\(difference)-"
                }
                stringRoute.removeLast()
                
                groupArray[x].route = stringRoute
            }else if (destinationN >= 8 && destinationN <= 13){
                groupArray[x].travelTime = 2 + (13-destinationN)
                
                var stringRoute = "0-1-13-"
                if destinationN != 13{
                    for i in 1..<(13-destinationN)+1{
                        stringRoute += "\(13-i)-"
                    }
                    stringRoute.removeLast()
                    groupArray[x].route = stringRoute
                }else{
                    groupArray[x].route = "0-1-13"
                }
            }
            
        }
        
    }
    
    func setWaitingTime(){
        
        groupArray[0].waitingTime = 0
        
        for x in 1..<groupArray.count{
            groupArray[x].waitingTime = groupArray[x-1].waitingTime + groupArray[x-1].travelTime
        }
        
        print(groupArray)
        
    }

}
