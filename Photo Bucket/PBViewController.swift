//
//  PBViewController.swift
//  Photo Bucket
//
//  Created by Theo Yin on 8/8/21.
//

import UIKit

class PBViewController: UITableViewController {
    let pbCellIdentifier = "PBCellIdentifier"
    let detailSegueID = "DetailSegue"
    var pbs = [PB]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddPBDialog))
        
        
        pbs.append(PB(url: "https://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg", caption: "test img1"))
        pbs.append(PB(url: "https://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG", caption: "test img2"))
        
    }
    
    
    @objc func showAddPBDialog(){
        //CRUD
        let alertController = UIAlertController(title: "Create a new Photo Entry", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //configure
        alertController.addTextField { urlTextField in
            urlTextField.placeholder = "URL"
        }
        alertController.addTextField { capTextField in
            capTextField.placeholder = "caption"
        }
        let submitAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { action in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueID {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PBDetailViewController).pb = pbs[indexPath.row]
            }
        }
    }
    
}
