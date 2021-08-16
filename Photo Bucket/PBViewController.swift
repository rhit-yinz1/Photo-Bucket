//
//  PBViewController.swift
//  Photo Bucket
//
//  Created by Theo Yin on 8/8/21.
//

import UIKit
import Firebase

class PBViewController: UITableViewController {
    let pbCellIdentifier = "PBCellIdentifier"
    let detailSegueID = "DetailSegue"
    var pbs = [PB]()
    var PBRef: CollectionReference!
    var pbListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddPBDialog))

        PBRef = Firestore.firestore().collection("PhotoBucket")
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
            self.PBRef.addDocument(data: [
                "imgUrl": urlTextField.text!,
                "imgCaption": capTextField.text!,
                "created": Timestamp.init()
            ])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        PBRef.order(by: "created", descending: true).limit(to: 50).addSnapshotListener { querySnapshot, error in
            self.pbs.removeAll()
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.forEach { queryDocumentSnapshot in
                    print(queryDocumentSnapshot.documentID)
                    print(queryDocumentSnapshot.data())
                    self.pbs.append(PB(documentSnapshot: queryDocumentSnapshot))
                    self.tableView.reloadData()
                }
            } else {
                print("error getting data ")
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        pbListener.remove() 
        
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
            let pbToDelete = pbs[indexPath.row]
            PBRef.document(pbToDelete.id!).delete()
           
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueID {
            if let indexPath = tableView.indexPathForSelectedRow {
//                (segue.destination as! PBDetailViewController).pb = pbs[indexPath.row]
                (segue.destination as! PBDetailViewController).pbRef = PBRef.document(pbs[indexPath.row].id!)
            }
        }
    }
    
}
