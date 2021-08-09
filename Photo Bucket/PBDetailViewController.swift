//
//  PBDetailViewController.swift
//  Photo Bucket
//
//  Created by Theo Yin on 8/8/21.
//

import UIKit

class PBDetailViewController: UIViewController {
    
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    var pb: PB?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditDialog))
        updateView()
    }
    
    @objc func showEditDialog(){
        let alertController = UIAlertController(title: "Photo Caption", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //configure

        alertController.addTextField { capTextField in
            capTextField.placeholder = "caption"
            capTextField.text = self.pb?.caption
        }
        let submitAction = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) { action in
            let capTextField = alertController.textFields![0] as UITextField
            self.pb?.caption = capTextField.text!
            self.updateView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func updateView(){
        capLabel.text = pb?.caption
        if let imgString = pb?.url {
            if let imgUrl = URL(string: imgString) {
                DispatchQueue.global().async { // Download in the background
                    do {
                        let data = try Data(contentsOf: imgUrl)
                        DispatchQueue.main.async { // Then update on main thread
                            self.photoView.image = UIImage(data: data)
                        }
                    } catch {
                        print("Error downloading image: \(error)")
                    }
                }
            }
        } else {
            let iURL = URL(string: getRandomImageUrl())
            DispatchQueue.global().async { // Download in the background
                do {
                    let data = try Data(contentsOf: iURL!)
                    DispatchQueue.main.async { // Then update on main thread
                        self.photoView.image = UIImage(data: data)
                    }
                } catch {
                    print("Error downloading image: \(error)")
                }
            }
            
            
        }
    }
    
    func getRandomImageUrl() -> String {
        let testImages = ["https://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG",
                          "https://upload.wikimedia.org/wikipedia/commons/6/6b/Mount_Carmel_forest_fire14.jpg"]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }
    
    
}
