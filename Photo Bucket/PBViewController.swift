//
//  PBViewController.swift
//  Photo Bucket
//
//  Created by Theo Yin on 8/8/21.
//

import UIKit

class PBViewController: UITableViewController {
    let pbCellIdentifier = "PBCellIdentifier"
    var pbs = [PB]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddPBDialog))
        
        
        pbs.append(PB(url: "urrrl1", caption: "things1"))
        pbs.append(PB(url: "urrrl2", caption: "things2"))
        
    }
    
    
    @objc func showAddPBDialog(){
        //CRUD
        let alertController = UIAlertController(title: "new PB", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //configure
        alertController.addTextField { urlTextField in
            urlTextField.placeholder = "URL"
        }
        alertController.addTextField { capTextField in
            capTextField.placeholder = "caption"
        }
        let submitAction = UIAlertAction(title: "Create Photo", style: UIAlertAction.Style.default) { action in
            let urlTextField = alertController.textFields![0] as UITextField
            let capTextField = alertController.textFields![1] as UITextField
            let newPB = PB(url: urlTextField.text!, caption: capTextField.text!)
            self.pbs.insert(newPB, at: 0)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pbs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pbCellIdentifier, for: indexPath)
        //configure cell
        cell.textLabel?.text = pbs[indexPath.row].caption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            pbs.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
