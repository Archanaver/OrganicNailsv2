//
//  DatosFacturaViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase

class DatosFacturaViewController: UIViewController{
    
    var cliente:Cliente?
    
    @IBOutlet weak var rfcTextField: UITextField!
    
    @IBOutlet weak var cpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func guardarButton(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
