//
//  PromocionesDetalleViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/5/21.
//

import UIKit

class PromocionesDetalleViewController: UIViewController {
    
    //Creamos el producto
    var prod = Producto(nombre: "", id: "", colores: [""], precio: [0], descripcion: "", tipo: "", descuento: 1, uso: "", producto: "", presentacion: [""])
    
    
    //Variables para los selects
    let presentacion = ["N/a"]
    
    //Variable que va a traer del otro lugar
    var producto:Producto?
    
    //Llamamos el controlador
    var productosControlador = ProductoControlador()
    
    //Variable a actualizar
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var ahorras: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text? = producto?.nombre ?? ""
        /*
        productosControlador.presentaciones(p: producto ?? prod)´(result) in switch result {
        case .success(let productos):self.updateUI(with: productos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
        */
        
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        productosControlador.fetchProductosTipo(tipo: producto.text!){ (result) in switch result {
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
    
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
