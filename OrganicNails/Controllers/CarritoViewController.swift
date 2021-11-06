//
//  CarritoViewController.swift
//  OrganicNails
//
//  Created by user189673 on 11/5/21.
//

import UIKit
import Firebase

class CarritoViewController: UIViewController, UISearchResultsUpdating {

    var opcion: String = ""
    var filtradoTipo:Int = 0
    var categoria:String = ""
    
    let db = Firestore.firestore()
    
    //let productos = ["a", "b", "c"]
    
    var carritos = [Pedido]()
    var carritoControlador = PedidoControlador()
    var datosFiltrados = [Pedido]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var carritoTableView: UITableView!
    
   
    
    
    
    func updateSearchResults(for searchController: UISearchController){
        if searchController.searchBar.text! == "" {
            datosFiltrados = carritos
        }else{
            datosFiltrados = carritos.filter{
                let s:String = $0.fecha
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))}

        }
        self.carritoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carritoTableView.delegate = self
        carritoTableView.dataSource = self
       
        // Do any additional setup after loading the view.
        carritoControlador.fetchPedidos{ (resultado) in
            switch resultado{
            case .success(let listaPedidos):self.updateGUI(listaPedidos: listaPedidos)
            case .failure(let error):self.displayError(e: error)
            }
            
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        carritoTableView.tableHeaderView = searchController.searchBar
    }
    
    func updateGUI(listaPedidos: Pedidos){
        DispatchQueue.main.async {
            //self.cursos = listaCursos
            if self.filtradoTipo == 0{
                self.filtrarPorFecha(listaPedidos: listaPedidos)
            }
            self.datosFiltrados = listaPedidos
            self.carritoTableView.reloadData()
        }
       
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
       
    }
    func filtrarPorFecha(listaPedidos: Pedidos){
        for c in listaPedidos{
            if c.fecha == self.opcion{
                self.carritos.append(c)
            }
        }
        
    }
   
    
    }

    
    
    

extension CarritoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        carritoTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CarritoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datosFiltrados.count
    }

    //construye cada celda, lo que se ve visualmente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = datosFiltrados[indexPath.row].fecha

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
