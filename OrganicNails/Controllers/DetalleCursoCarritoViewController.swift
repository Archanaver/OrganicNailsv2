//
//  DetalleCursoCarritoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/20/21.
//

import UIKit

class DetalleCursoCarritoViewController: UIViewController {
    var curso:CursoP?
  
    @IBOutlet weak var nombre: UILabel!

    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var precio: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text = curso?.nombre_curso
        fecha.text = curso?.fecha_curso
        instructor.text = curso?.instructor
        precio.text = curso?.precio_curso
        descripcion.text = curso?.descripcion_curso
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
