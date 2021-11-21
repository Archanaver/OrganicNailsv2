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
    @IBOutlet weak var totalLabel: UILabel!
    var total:Float = 0
    
    @IBOutlet weak var comprar: UIButton!
    @IBOutlet var productosTableView: UITableView!
    
    @IBOutlet var cursosTableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        var pedidoId:String = ""
        pedidoControlador.checarCarrito(){
            (resultado) in
            switch resultado{
                case .success(let exito):pedidoId = exito
                    if pedidoId.count != 0 {
                        self.pedidoControlador.fetchCarritoProductos(pedidoActivo: pedidoId){ (resultado) in
                            switch resultado{
                                case .success(let listaProductos):self.updateGUI(listaProductos: listaProductos)
                                    self.pedidoControlador.fetchCarritoCursos(pedidoActivo: pedidoId){ (resultado) in
                                        switch resultado{
                                            case .success(let listaCursos):self.updateGUICursos(listaCursos: listaCursos)
                                            case .failure(let error):self.displayError(e: error)
                                        }
                                    }
                                case .failure(let error):self.displayError(e: error)
                            }
                        }
                    }else{
                        self.comprar.isHidden = true
                        self.mensajeCarritoVacio()
                    }
                case .failure(let error):print(error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productosTableView.delegate = self
        productosTableView.dataSource = self
        
        cursosTableView.delegate = self
        cursosTableView.dataSource = self
        

        var pedidoId:String = ""
        pedidoControlador.checarCarrito(){
            (resultado) in
            switch resultado{
                case .success(let exito):pedidoId = exito
                    if pedidoId.count != 0 {
                        self.pedidoControlador.fetchCarritoProductos(pedidoActivo: pedidoId){ (resultado) in
                            switch resultado{
                                case .success(let listaProductos):self.updateGUI(listaProductos: listaProductos)
                                    self.pedidoControlador.fetchCarritoCursos(pedidoActivo: pedidoId){ (resultado) in
                                        switch resultado{
                                            case .success(let listaCursos):self.updateGUICursos(listaCursos: listaCursos)
                                                //print("update")
                                                //self.calculaTotal()
                                            case .failure(let error):self.displayError(e: error)
                                        }
                                    }
                                case .failure(let error):self.displayError(e: error)
                            }
                        }
                    }else{
                        self.comprar.isHidden = true
                        self.mensajeCarritoVacio()
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
    
    
    func mensajeCarritoVacio(){
        let alerta =  UIAlertController(title: "Carrito vacío", message: "No hay productos/cursos añadidos en el carrito", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
    func updateGUICursos(listaCursos: [CursoP]){
        DispatchQueue.main.async {
            self.cursos = listaCursos
            if self.productos.isEmpty && self.cursos.isEmpty{
                self.comprar.isHidden = true
                self.mensajeCarritoVacio()
            }else{
                self.comprar.isHidden = false
            }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! EditarProductoViewController
        let indice = self.productosTableView.indexPathForSelectedRow?.row
        siguiente.producto = productos[indice!]
    }
    
    func calculaTotal() -> Float{
        total = 0
        
        for p in productos{
            var tempPrecio = p.precio_producto * Float(p.cantidad_producto)
            if p.descuento_producto != 0{
                let descuento = (tempPrecio * Float( p.descuento_producto))/100
                let precioConDesc = tempPrecio - descuento
                tempPrecio = precioConDesc
            }
            total += tempPrecio
            
        }

        for c in cursos{
            total += Float(c.precio_curso) ?? 0
        }
        //print("total: ", total)
        return total
    }

    

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
        // #warning Incomplete implementation, return the number of rows
        if tableView.tag == 0{
            return productos.count
        }else{
            return cursos.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Choose your custom row height
        if tableView.tag == 0{
            return 150.0;
        }else{
            return 100;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 0{
            return "Productos"
        }else{
            return "Cursos"
        }
    }

    //construye cada celda, lo que se ve visualmente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        totalLabel.text = "Total: $\( calculaTotal())"
        // Configure the cell...
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath as IndexPath)as! ProductoUITableViewCell
            cell.tituloCell.text = productos[indexPath.row].nombre_producto
            cell.colorCell.text = "Color: \(productos[indexPath.row].color)"
            
            cell.cantidadCell.text = "Cantidad: \(productos[indexPath.row].cantidad_producto)"
            let tempPrecio = productos[indexPath.row].precio_producto * Float(productos[indexPath.row].cantidad_producto)
            cell.precioCell.text = "Precio: $ \(String(tempPrecio))"
            cell.descuentoCell.isHidden = true
            if productos[indexPath.row].descuento_producto != 0{
                cell.descuentoCell.isHidden = false
                cell.descuentoCell.text = "Descuento: \(String(productos[indexPath.row].descuento_producto)) %"
                let desc = ((productos[indexPath.row].precio_producto * Float(productos[indexPath.row].descuento_producto))/100) * Float(productos[indexPath.row].cantidad_producto)
             
               cell.totalCell.text = "Total: $ \(String(tempPrecio - desc ))"
            }else{
                cell.totalCell.text = "Total: $ \(String(productos[indexPath.row].precio_producto * Float(productos[indexPath.row].cantidad_producto)))"

            }
            
            if let btnDeleteProducto = cell.contentView.viewWithTag(101) as? UIButton {
                btnDeleteProducto.addTarget(self, action: #selector(deleteRowProducto(_ :)), for: .touchUpInside)
            }
            return cell
            
        }else{
            // Configure the cell...
            let cell = tableView.dequeueReusableCell(withIdentifier: "zelda2", for: indexPath as IndexPath)as! CursoTableViewCell
            cell.titulo.text = cursos[indexPath.row].nombre_curso
            cell.fecha.text = "Fecha: \(cursos[indexPath.row].fecha_curso)"
            cell.total.text = "Total: $ \(cursos[indexPath.row].precio_curso)"
            
            if let btnDeleteCurso = cell.contentView.viewWithTag(102) as? UIButton{
                btnDeleteCurso.addTarget(self, action: #selector(deleteRowCurso(_ :)), for: .touchUpInside)
            }
            return cell
        }
    }
    
   
    
    @objc func deleteRowCurso(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: cursosTableView)
        guard let indexPath = cursosTableView.indexPathForRow(at: point)else{
            return
        }
        cursosTableView.beginUpdates()
        pedidoControlador.deleteCursoP(idDoc: cursos[indexPath.row].idDoc, idPedido: cursos[indexPath.row].id_pedido){
            (resultado) in
            switch resultado{
            case .success(let exito):print(exito)
                self.cursos.remove(at: indexPath.row)
                self.cursosTableView.deleteRows(at: [indexPath], with: .left)
                
                self.totalLabel.text = "Total: $\( self.calculaTotal())"
                if self.productos.isEmpty && self.cursos.isEmpty{
                    self.comprar.isHidden = true
                    self.mensajeCarritoVacio()
                }
            case .failure(let error):print(error)
            }
        }
        cursosTableView.endUpdates()
    
    }
    
    @objc func deleteRowProducto(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: productosTableView)
        guard let indexPath = productosTableView.indexPathForRow(at: point)else{
            return
        }
        productosTableView.beginUpdates()
        pedidoControlador.deleteProductoP(idDoc: productos[indexPath.row].idDoc, idPedido: productos[indexPath.row].id_pedido){
            (resultado) in
            switch resultado{
            case .success(let exito):print(exito)
                self.productos.remove(at: indexPath.row)
                self.productosTableView.deleteRows(at: [indexPath], with: .left)
                
                self.totalLabel.text = "Total: $\( self.calculaTotal())"
                if self.productos.isEmpty && self.cursos.isEmpty{
                    self.comprar.isHidden = true
                    self.mensajeCarritoVacio()
                }
            case .failure(let error):print(error)
            }
        }
        productosTableView.endUpdates()
    }

    
    
    
}
