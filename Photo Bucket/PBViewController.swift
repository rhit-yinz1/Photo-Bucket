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
        pbs.append(PB(url: "urrrl1", caption: "things1"))
        pbs.append(PB(url: "urrrl2", caption: "things2"))

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
}
