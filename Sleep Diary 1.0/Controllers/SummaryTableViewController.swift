//
//  SummaryTableViewController.swift
//  Sleep Diary 1.0
//
//  Created by VIS Swimming on 25/5/18.
//  Copyright © 2018 TOR. All rights reserved.
//

import UIKit
import Firebase

class SummaryTableViewController: UITableViewController {

    var sleep: [SleepEntry] = []
    
    //firebase
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedSleep = SleepEntry.loadList() {
            self.sleep = savedSleep
        }
    }

//Log out actions
    @IBAction func logOutButtonPressed(_ sender: Any) {
//        UserDefaults.standard.set(false, forKey: "UserIsLoggedIn")
        UserDefaults.standard.set(false, forKey: "UserIsLoggedIn")
        let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logInVC") as! LoginViewController
        self.present(logInVC, animated: true, completion: nil)
    }

//Table properties
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleep.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepEntryTableViewCell") else {
            fatalError("Count not dequeue a cell")
        }
         let sleepEntry = sleep[indexPath.row]
//cell properties
        cell.textLabel?.text = sleepEntry.dateLabel
        cell.detailTextLabel?.text = "Sleep Quality: "+sleepEntry.sleepQuality
        cell.backgroundColor = .black
       
//changes colour of detailed text according to sleep quality
    switch (cell.detailTextLabel?.text) {
        case "Sleep Quality: Very Good":
            cell.detailTextLabel?.textColor = .green
        case "Sleep Quality: Good":
            cell.detailTextLabel?.textColor = .magenta
        case "Sleep Quality: Average":
            cell.detailTextLabel?.textColor = .yellow
        case "Sleep Quality: Poor":
            cell.detailTextLabel?.textColor = .orange
            
        default: cell.detailTextLabel?.textColor = .red
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let entry = SleepEntry[indexPath.row]
        
        if editingStyle == .delete {
            let sleepEntry = sleep[indexPath.row]
            let email = getEmail()
            self.ref.child("users").child(email).child(sleepEntry.dateLabel).removeValue()
            sleep.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SleepEntry.saveToFile(sleepEntry: sleep)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSleepEntry" {
            let staticTableViewController = segue.destination as! StaticEntryTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedSleepEntry = sleep[indexPath.row]
            staticTableViewController.newSleepEntry = selectedSleepEntry
        }
    }

    func getEmail() -> String {
        return UserDefaults.standard.object(forKey: "UserEmail") as! String
    }

 //segues for save and delete
    @IBAction func unwindToParcelList(segue: UIStoryboardSegue) {
        
        let sourceViewController = segue.source as! StaticEntryTableViewController

        if let sleepSave = sourceViewController.newSleepEntry, segue.identifier == "saveUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                sleep[selectedIndexPath.row] = sleepSave
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
            } else {
                let newIndexPath = IndexPath(row: sleep.count, section: 0)
                sleep.append(sleepSave)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
            }
        } else if segue.identifier == "deleteUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let sleepEntry = sleep[selectedIndexPath.row]
                let email = getEmail()
                self.ref.child("users").child(email).child(sleepEntry.dateLabel).removeValue()
                sleep.remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                tableView.reloadData()
            }
        }

        SleepEntry.saveToFile(sleepEntry: sleep)
    }
    
}

