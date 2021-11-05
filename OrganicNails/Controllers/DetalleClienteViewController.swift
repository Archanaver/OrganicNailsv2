//
//  DetalleClienteViewController.swift
//  OrganicNails
//
//  Created by user189475 on 10/25/21.
//

import UIKit

class DetalleClienteViewController: UIViewController {
    var cliente:String = ""
    @IBOutlet weak var clienteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clienteTextField.text = cliente
        // Do any additional setup after loading the view.
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
