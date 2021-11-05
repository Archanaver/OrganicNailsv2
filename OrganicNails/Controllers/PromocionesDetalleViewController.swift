//
//  PromocionesDetalleViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/5/21.
//

import UIKit

class PromocionesDetalleViewController: UIViewController {
    
    //Variables para los selects
    var presentacion = ["N/a"]
    
    //Variable que va a traer del otro lugar
    var producto:Producto?
    
    //Llamamos el controlador
    var productosControlador = ProductoControlador()
    
    //Variable a actualizar
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var presentacionProd: UITextField!
    @IBOutlet weak var ahorras: UILabel!
    
    
    //Creamos el pickerview
    var presentacionPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text? = producto?.nombre ?? ""
        presentacion = productosControlador.presentaciones(p: producto!)
        
        presentacionPickerView.delegate = self
        presentacionPickerView.dataSource = self
        
        //Damos las vistas a cada field
        presentacionProd.inputView = presentacionPickerView
        
        //Obtenemos tag
        presentacionPickerView.tag = 1
        
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

extension PromocionesDetalleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return presentacion.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return presentacion[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            presentacionProd.text = presentacion[row]
            presentacionProd.resignFirstResponder()
        
        //Cambiamos las demàs variables
            var precioActual = String((producto?.precio[row])!)
            precio.text? = precioActual
            ahorras.text? = String((producto?.descuento)!)
            
        default:
            return
        }
    }
}

