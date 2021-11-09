//
//  CarritoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/6/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class DespliegueCarritoViewController: UIViewController, UISearchResultsUpdating {

    let db = Firestore.firestore()
    
    
    var carritos = [ProductoP]()
    var carritoControlador = PedidoControlador()
    var datosFiltrados = [ProductoP]()
    var carritosCurso = [CursoP]()
    var carritoControladorCurso = PedidoControlador()
    var datosFiltradosCurso = [CursoP]()
    
    let searchController = UISearchController(searchResultsController: nil)
    let searchControllerCurso = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var carritoTableView: UITableView!
    
    @IBOutlet weak var carritoCursoTableView: UITableView!
    
    
    
    func updateSearchResults(for searchController: UISearchController){
        if searchController.searchBar.text! == "" {
            datosFiltrados = carritos
        }else{
            datosFiltrados = carritos.filter{
                let s:String = $0.nombre_producto
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))}

        }
        self.carritoTableView.reloadData()
    }
    func updateSearchResultsCurso(for searchControllerCurso: UISearchController){
        if searchControllerCurso.searchBar.text! == "" {
            datosFiltradosCurso = carritosCurso
        }else{
            datosFiltradosCurso = carritosCurso.filter{
                let p:String = $0.nombre_curso
                return(p.lowercased().contains(searchControllerCurso.searchBar.text!.lowercased()))}

        }
        self.carritoCursoTableView.reloadData()
    }
    func getIdPedido(id:String)->String{
            DispatchQueue.main.async {
            }
            return id
        }
  override func viewDidAppear(_ animated: Bool) {
    
    carritoControlador.fetchCarritoUsuario(idPedido: "rS2JEskBc2ru5HjdSo9D"){ (resultado) in
            switch resultado{
            case .success(let listaProductosP):self.updateGUI(listaProductosP: listaProductosP)
            case .failure(let error):self.displayError(e: error)
            }
            
        }
    carritoControlador.fetchCarritoCursosUsuario(idPedido: "rS2JEskBc2ru5HjdSo9D"){ (resultadoCurso) in
            switch resultadoCurso{
            case .success(let listaCursosP):self.updateGUICurso(listaCursosP: listaCursosP)
            case .failure(let error):self.displayError(e: error)
            }
            
        }

    }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        carritoTableView.delegate = self
        carritoTableView.dataSource = self
        carritoCursoTableView.delegate = self
        carritoCursoTableView.dataSource = self
               //let userID = Auth.auth().currentUser!.uid
        //var idPedidoActivo = ""
        carritoControlador.fetchCarritoUsuario(idPedido: "rS2JEskBc2ru5HjdSo9D"){ (resultado) in
            switch resultado{
            case .success(let listaProductosP):self.updateGUI(listaProductosP: listaProductosP)
            case .failure(let error):self.displayError(e: error)
            }
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        carritoTableView.tableHeaderView = searchController.searchBar
        
        carritoControladorCurso.fetchCarritoCursosUsuario(idPedido: "rS2JEskBc2ru5HjdSo9D"){ (resultado) in
            switch resultado{
            case .success(let listaCursosP):self.updateGUICurso(listaCursosP: listaCursosP)
            case .failure(let error):self.displayError(e: error)
            }
        }
        
        searchControllerCurso.searchResultsUpdater = self
        searchControllerCurso.dimsBackgroundDuringPresentation = false
        searchControllerCurso.hidesNavigationBarDuringPresentation = false
        carritoCursoTableView.tableHeaderView = searchControllerCurso.searchBar
    }
    
    func updateGUI(listaProductosP: ProductosP){
        DispatchQueue.main.async {
            self.carritos = listaProductosP
            self.datosFiltrados = listaProductosP
            self.carritoTableView.reloadData()
        }
    }
        func updateGUICurso(listaCursosP: CursosP){
            DispatchQueue.main.async {
                self.carritosCurso = listaCursosP
                self.datosFiltradosCurso = listaCursosP
                self.carritoCursoTableView.reloadData()
            }
       
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
       
    }

    
    func numberOfSections(in carritoTableView: UITableView) -> Int{
        return 1
    }
    
    func numberOfSectionsCurso(in carritoCursoTableView: UITableView) -> Int{
        return 1
    }
    
    
}

extension DespliegueCarritoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        carritoTableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableViewCurso(_ tableViewCurso: UITableView, didSelectRowAt indexPath: IndexPath) {
        carritoCursoTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension DespliegueCarritoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datosFiltrados.count
    }
    func tableViewCurso(_ tableViewCurso: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datosFiltradosCurso.count
    }
    
    

    //construye cada celda, lo que se ve visualmente
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        // Configure the cell...
        print("PRODUCT",datosFiltrados[indexPath.row])
        cell.textLabel?.text = datosFiltrados[indexPath.row].nombre_producto
        return cell
    }
    
    func tableViewCurso(_ tableViewCurso: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellCurso = tableViewCurso.dequeueReusableCell(withIdentifier: "zelda2", for: indexPath)
    // Configure the cell...
    print("CURSO",datosFiltradosCurso[indexPath.row])
    cellCurso.textLabel?.text = datosFiltradosCurso[indexPath.row].nombre_curso
        return cellCurso
        
    }
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        }
    func tableViewCurso(_ tableViewCurso: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

       }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableViewCurso(_ tableViewCurso: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the item to be re-orderable.
           return true
       }
    func tableViewCurso(_ tableViewCurso: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
    func tableViewCurso(_ tableViewCurso: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
            tableViewCurso.deleteRows(at: [indexPath], with: .fade)
          } else if editingStyle == .insert {
              // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
          }
      }

}

