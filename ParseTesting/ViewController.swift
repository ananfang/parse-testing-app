//
//  ViewController.swift
//  ParseTesting
//
//  Created by ananfang on 09/02/2018.
//  Copyright © 2018 ananfang. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var messageObjects = [PFObject]()
    
    var liveQueryClient: Client?
    var subscription: Subscription<PFObject>?
    
    let hellos = ["Bonjour", "Hola", "Zdravstvuyte", "你好", "Salve", "こんにちは", "Guten Tag", "Olá", "안녕하세요", "Asalaam alaikum", "Hello"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageQuery().findObjectsInBackground().continueOnSuccessWith(executor: BFExecutor.mainThread(), block: { [weak self] task in
            guard let strongSelf = self else { return nil }
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
        
        liveQueryClient = ParseLiveQuery.Client(server: "wss://testingapp1256.back4app.io")
        
        subscription = liveQueryClient?.subscribe(messageQuery())
        subscription?.handle(Event.created, { _, message in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.messageObjects.insert(message, at: 0)
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    func messageQuery() -> PFQuery<PFObject> {
        let query = PFQuery(className: "Message")
        query.whereKeyExists("createdAt")
        query.order(byDescending: "createdAt")
        return query
    }
    
    @IBAction func didTapAddMessage(_ sender: UIButton) {
        let hello = hellos[messageObjects.count % hellos.count]
        
        let message = PFObject(className: "Message")
        message.setValue(hello, forKey: "message")
        
        
        message.saveEventually()
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Message Cell")
        
        let message = messageObjects[indexPath.row]
        cell.textLabel?.text = message.value(forKey: "message") as? String
        cell.detailTextLabel?.text = "\(message.createdAt ?? Date(timeIntervalSince1970: 0))"
        
        return cell
    }
}
