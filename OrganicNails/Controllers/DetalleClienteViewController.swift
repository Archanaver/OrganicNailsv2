//
//  DetalleClienteViewController.swift
//  OrganicNails
//
//  Created by user189475 on 10/25/21.
//

import UIKit
import FirebaseAuth

class DetalleClienteViewController: UIViewController {
    
    let clienteControlador = ClienteControlador()
    
    
    var cliente:Cliente?
    
    @IBOutlet weak var nombreLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreLabel.text = cliente?.nombre
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateCliente(_ sender: Any) {
        
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
