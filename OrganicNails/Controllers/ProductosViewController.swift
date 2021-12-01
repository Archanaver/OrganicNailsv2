//
//  ProductosViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import UIKit
import Firebase

class ProductosViewController: UIViewController, UISearchResultsUpdating {
    var opcion: String = ""
    var filtradoTipo:Bool = false
    var categoria:String = ""
    
    let db = Firestore.firestore()
    //let productos = ["a", "b", "c"]
    var productos = [Producto]()
    var productoControlador = ProductoControlador()
    var datosFiltrados = [Producto]()
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var productosTableView: UITableView!

    @IBOutlet weak var labelOpcion: UILabel!
    func updateSearchResults(for searchController: UISearchController){
        if searchController.searchBar.text! == "" {
            datosFiltrados = productos
        }else{
            datosFiltrados = productos.filter{
                let s:String = $0.nombre
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))}

        }
        self.productosTableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        productosTableView.delegate = self
        productosTableView.dataSource = self
        labelOpcion.text = self.opcion
        // Do any additional setup after loading the view.
        productoControlador.fetchProductos{ (resultado) in
            switch resultado{
            case .success(let listaProductos):self.updateGUI(listaProductos: listaProductos)
            case .failure(let error):self.displayError(e: error)
            }
            
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.searchController = searchController
        
        //productosTableView.tableHeaderView = searchController.searchBar
    }
    
    func updateGUI(listaProductos: Productos){
        DispatchQueue.main.async {
            //self.productos = listaProductos
            if self.filtradoTipo {
                self.filtrarPorTipo(listaProductos: listaProductos)
                
            }else{
                self.filtrarPorCategoría(listaProductos: listaProductos)
            }
            
            self.datosFiltrados = self.productos
            self.productosTableView.reloadData()
        }
        
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    func filtrarPorTipo(listaProductos: Productos){
        for producto in listaProductos{
            if producto.tipo == self.opcion{
                self.productos.append(producto)
            }
        }
    }
    
    func filtrarPorCategoría(listaProductos: Productos){
        for p in listaProductos{
            if p.producto == self.opcion{
                self.productos.append(p)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
            let siguiente = segue.destination as! DetalleProductoViewController
            let indice = self.productosTableView.indexPathForSelectedRow?.row
            siguiente.producto = datosFiltrados[indice!]
    }
    

}
//override
    func numberOfSections(in productosTableView: UITableView) -> Int{
    return 1
}

extension ProductosViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productosTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ProductosViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datosFiltrados.count
    }

    //construye cada celda, lo que se ve visualmente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = datosFiltrados[indexPath.row].nombre

        return cell
    }
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the item to be re-orderable.
           return true
       }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               tableView.deleteRows(at: [indexPath], with: .fade)
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
    
}
