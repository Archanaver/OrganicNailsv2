//
//  DetalleProductoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import UIKit

class DetalleCursoViewController: UIViewController {
    var curso:Curso?
    
    @IBOutlet weak var nombre: UILabel!
    
   
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var precio: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text = curso?.nombre
        fecha.text = curso?.fecha
        instructor.text = curso?.instructor
        precio.text = String(format: "%.2f",curso?.precio ?? 0)
        descripcion.text = curso?.descripcion
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
