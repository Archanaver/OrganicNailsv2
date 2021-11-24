//
//  DireccionEnvioViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/23/21.
//

import UIKit

class DireccionEnvioViewController: UIViewController {
    var total:Float = 0
    var ahorro:Float = 0
    var envio:Float = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetallePedidoViewController
        siguiente.ahorro = ahorro
        siguiente.total = total
    }
    
 

}
