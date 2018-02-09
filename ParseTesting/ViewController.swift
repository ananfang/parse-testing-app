//
//  ViewController.swift
//  ParseTesting
//
//  Created by ananfang on 09/02/2018.
//  Copyright © 2018 ananfang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var messageObjects = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground().continueOnSuccessWith(executor: BFExecutor.mainThread(), block: { [weak self] task in
            guard let strongSelf = self else { return nil }
            print(task.result)
            if let objects = task.result as? [PFObject] {
                strongSelf.messageObjects = objects
                strongSelf.tableView.reloadData()
            }
            
            return nil
        }).continueWith(block: { task in
            if let error = task.error {
                print(error.localizedDescription)
            }
            
            return nil
        })
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Message Cell")
        
        let message = messageObjects[indexPath.row]
        cell.textLabel?.text = "\(message.createdAt ?? Date(timeIntervalSince1970: 0))"
        
        return cell
    }
}
