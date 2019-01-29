//
//  GuideTableViewController.swift
//  iOS Coding Challenge One
//
//  Created by Zachery Miller on 1/28/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit

class GuideTableViewController: UITableViewController {
    
    var guideCollection : GuideCollection?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getGuidesFromAPICall()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func guide(at indexPath: IndexPath) -> Guide?{
        if let date = guideCollection?.guideStartDates[indexPath.section] {
            return (guideCollection?.guidesByStartDate[date]?[indexPath.row])!
        }
        return nil
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return guideCollection?.guideStartDates.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let date = guideCollection?.guideStartDates[section]
        return guideCollection?.guidesByStartDate[date!]?.count ?? 1
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Subtitle", for: indexPath)

        let guide = self.guide(at : indexPath)
        
        if let name = guide?.name {
            cell.textLabel?.text = name
        }
        
        if let endDate = guide?.endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let endDateAsString = dateFormatter.string(from: endDate)
            cell.detailTextLabel?.text = "Ends - \(endDateAsString)"
        }
        
        if let city = guide?.city {
            cell.detailTextLabel?.text?.append(" : \(city)")
        }
        
        if let state = guide?.state {
            cell.detailTextLabel?.text?.append(", \(state)")

        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let date = guideCollection?.guideStartDates[section] {
            let dateAsString = dateFormatter.string(from: date)
            return dateAsString
        }
        return ""
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func getGuidesFromAPICall() {
        let guideURL = "https://www.guidebook.com/service/v2/upcomingGuides/"
        
        guard let url = URL(string: guideURL) else {
            print("ERROR: Can't create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on \(guideURL)")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: No data received")
                return
            }
            
            do {
                guard let guideData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                self.guideCollection = GuideCollection(json: guideData)
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
}
