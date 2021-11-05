//
//  PromocionesInicioViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/5/21.
//

import UIKit

class PromocionesInicioViewController: UIViewController {

    //Instanciamos la clase
    var productosControlador = ProductoControlador()
    
    //Creamos las variables
    var datos = [Producto]()
    var promos = [Producto]()
    @IBOutlet weak var producto: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //Variables para los selects
    let productosOp = ["Acrílicos", "Kits", "Glitters", "Líquidos", "Consumibles", "Herramientas", "Tratamientos", "Accesorios", "Arte", "Todos"]
    
    //Creamos el pickerview
    var productoPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        productoPickerView.delegate = self
        productoPickerView.dataSource = self
        
        //Damos las vistas a cada field
        producto.inputView = productoPickerView
        
        //Obtenemos tag
        productoPickerView.tag = 1
        
        /*
        productosControlador.fetchProductosTipo(tipo: producto.text ?? "Todos"){ (result) in switch result {
        case .success(let productos):self.updateUI(with: productos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
 */
        productosControlador.fetchProductosTipo(tipo: "Todos"){ (result) in switch result {
        case .success(let productos):self.updateUI(with: productos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
    }
    
    //Función de update
    func updateUI(with productos:Productos) {
        DispatchQueue.main.async {
            self.datos = productos
            
            //Obtenemos las promociones de todos los productos de un tipo
            self.promos = self.productosControlador.productosPromo(listaProductos: self.datos)
            
            self.tableView.reloadData()
        }
    }
        
    //Función display error
    func displayError(_ error: Error, title:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style:.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         let siguiente = segue.destination as! ServiciosDetalleTableViewController
         let indice =  self.tableView.indexPathForSelectedRow?.row
         siguiente.servicio = datos[indice!]
         */
    }
    

}

extension PromocionesInicioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoCell", for: indexPath)
        cell.textLabel?.text = promos[indexPath.row].nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PRODUCTOS"
    }
    
    
}

extension PromocionesInicioViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return productosOp.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return productosOp[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            producto.text = productosOp[row]
            producto.resignFirstResponder()
        default:
            return
        }
    }
}
