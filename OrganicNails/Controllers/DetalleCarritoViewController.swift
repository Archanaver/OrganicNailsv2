//
//  DetalleCarritoViewController.swift
//  OrganicNails
//
//  Created by user189673 on 11/5/21.
//

import UIKit
import FirebaseAuth

class DetalleCarritoViewController: UIViewController {

    var carrito:Pedido?
   
    @IBOutlet weak var activo: UILabel!
   
    @IBOutlet weak var cliente_id: UILabel!
    @IBOutlet weak var pedido_id: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var estatus: UILabel!
    @IBOutlet weak var total: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cliente_id.text = carrito?.cliente_id
        pedido_id.text = carrito?.cliente_id
        fecha.text = carrito?.fecha
        direccion.text = carrito?.direccion
        descripcion.text = carrito?.productos.description
        total.text = "1000"
        estatus.text = carrito?.estatus
        //descripcion.text = curso?.descripcion
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
