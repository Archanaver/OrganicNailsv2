//
//  PruebaCarritoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/14/21.
//

import UIKit
import FirebaseAuth

class PruebaCarritoViewController: UIViewController {
    //let productos = ["a", "b", "c"]
    var productos = [ProductoP]()
    var pedidoControlador = PedidoControlador()
    
    var cursos = [CursoP]()
    var cursoControlador = CursoControlador()
    
    @IBOutlet weak var comprar: UIButton!
    @IBOutlet var productosTableView: UITableView!
    
    @IBOutlet var cursosTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        productosTableView.delegate = self
        productosTableView.dataSource = self
        
        cursosTableView.delegate = self
        cursosTableView.dataSource = self

        // Do any additional setup after loading the view.
        let userUID = Auth.auth().currentUser!.uid
        var pedidoId:String = ""
        //print("el id ",pedidoId)
        pedidoControlador.checarCarrito(){
            (resultado) in
            switch resultado{
            case .success(let exito):pedidoId = exito
                print("id del pedido activo", pedidoId)
                if pedidoId.count != 0 {
                    self.comprar.isHidden = false
                    self.pedidoControlador.fetchCarritoProductos(pedidoActivo: pedidoId){ (resultado) in
                        switch resultado{
                        case .success(let listaProductos):self.updateGUI(listaProductos: listaProductos)
                        case .failure(let error):self.displayError(e: error)
                        }
                        
                    }
                    self.pedidoControlador.fetchCarritoCursos(pedidoActivo: pedidoId){ (resultado) in
                        switch resultado{
                        case .success(let listaCursos):self.updateGUICursos(listaCursos: listaCursos)
                        case .failure(let error):self.displayError(e: error)
                        }
                        
                    }
                    
                }else{
                    self.comprar.isHidden = true
                    let alerta =  UIAlertController(title: "Carrito vacío", message: "No hay productos/cursos añadidos en el carrito", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
                    self.present(alerta, animated: true, completion: nil)
                }
            case .failure(let error):print(error)
            }
        }
        
    }
    
    func updateGUI(listaProductos: [ProductoP]){
        DispatchQueue.main.async {
            self.productos = listaProductos
            self.productosTableView.reloadData()
            
        }
        
    }
    
    func updateGUICursos(listaCursos: [CursoP]){
        DispatchQueue.main.async {
            self.cursos = listaCursos
            self.cursosTableView.reloadData()
        }
        
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetalleProductoViewController
        let indice = self.productosTableView.indexPathForSelectedRow?.row
        siguiente.producto = productos[indice!]
    }*/

}

extension PruebaCarritoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0{
            productosTableView.deselectRow(at: indexPath, animated: true)
            
        }else{
            cursosTableView.deselectRow(at: indexPath, animated: true)
            
        }

    }
    
}




extension PruebaCarritoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return productos.count
            
        }else{
            return cursos.count
            
        }
        // #warning Incomplete implementation, return the number of rows
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0;//Choose your custom row height
    }

    //construye cada celda, lo que se ve visualmente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath as IndexPath)as! ProductoUITableViewCell
            cell.tituloCell.text = productos[indexPath.row].nombre_producto
            cell.colorCell.text = "Color: \(productos[indexPath.row].color)"
            
            cell.cantidadCell.text = "Cantidad: \(productos[indexPath.row].cantidad_producto)"
            cell.precioCell.text = "Precio: $ \(String(productos[indexPath.row].precio_producto * Float(productos[indexPath.row].cantidad_producto)))"
            if productos[indexPath.row].descuento_producto != 0{
                cell.descuentoCell.text = "Descuento: \(String(productos[indexPath.row].descuento_producto)) %"
                let desc = (productos[indexPath.row].precio_producto * Float(productos[indexPath.row].descuento_producto))/100
                print("descuento", desc)
               cell.totalCell.text = "Total: $ \(String( productos[indexPath.row].precio_producto - (Float(productos[indexPath.row].cantidad_producto) * desc)))"
                
             
                
            }else{
                cell.totalCell.text = "Total: $ \(String(productos[indexPath.row].precio_producto * Float(productos[indexPath.row].cantidad_producto)))"
            }
           
           
           
            // Configure the cell...
            

            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "zelda2", for: indexPath)

            // Configure the cell...
            
                cell.textLabel?.text = cursos[indexPath.row].nombre_curso
                
            
          
            

            return cell
        }
    
        
      
    }
    

    
    
    
    
    
}
