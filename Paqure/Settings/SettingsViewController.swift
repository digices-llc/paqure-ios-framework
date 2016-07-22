//
//  SettingsViewController.swift
//  Paqure
//
//  Created by Linguri Technology on 7/21/16.
//  Copyright © 2016 Digices. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var sm : SettingsManager = SettingsManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sm.objects.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("setting", forIndexPath: indexPath)

        cell.textLabel?.text = sm.objects[indexPath.row].title

        return cell
    }


    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segue = "show\(sm.objects[indexPath.row].key)"
        self.performSegueWithIdentifier(segue, sender: self)
    }

}
