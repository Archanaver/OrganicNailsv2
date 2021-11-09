//
//  PedidosDetalleViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/7/21.
//

import UIKit

class PedidosDetalleViewController: UIViewController {
    
    //Variable que va a traer del otro lugar
    var pedido:Pedido?
    
    @IBOutlet weak var productosTableVierw: UITableView!
    
    var productos = [Producto]()
    var cursos = [Curso]()
    
    //Instanciamos la clase
    var productosControlador = ProductoControlador()
    var cursosControlador = CursoControlador()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productosTableVierw.delegate = self
        productosTableVierw.dataSource = self
        
        productosControlador.fetchProductosPedido(pedido: pedido!.id){ (result) in switch result {
        case .success(let productosP):self.updateUIP(with: productosP)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
        
        cursosControlador.fetchCursosPedido(pedido: pedido!.id){ (result) in switch result {
        case .success(let cursosP):self.updateUIC(with: cursosP)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
 

        // Do any additional setup after loading the view.
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        productosControlador.fetchProductosPedido(pedido: pedido!.id){ (result) in switch result {
        case .success(let productos):self.updateUIP(with: productos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
        
        cursosControlador.fetchCursosPedido(pedido: pedido!.id){ (result) in switch result {
        case .success(let cursosP):self.updateUIC(with: cursosP)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
    }
 
    //Función de update para productos
    func updateUIP(with productosP:Productos) {
        DispatchQueue.main.async {
            self.productos = productosP
         
            self.productosTableVierw.reloadData()
        }
    }
    
    //Función de update para cursos
    func updateUIC(with cursosP:Cursos) {
        DispatchQueue.main.async {
            self.cursos = cursosP
         
            self.productosTableVierw.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PedidosDetalleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cursos.count
        }
        else {
            return productos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detallePedidoCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = cursos[indexPath.row].nombre
            return cell
        }
        else {
            cell.textLabel?.text = productos[indexPath.row].nombre
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CURSOS"
        }
        else {
            return "PRODUCTOS"
        }
    }
    
    
}
