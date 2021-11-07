//
//  CursosViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//
import UIKit

class CursosViewController: UIViewController, UISearchResultsUpdating {
    //let productos = ["a", "b", "c"]
    var cursos = [Curso]()
    var cursoControlador = CursoControlador()
    var datosFiltrados = [Curso]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var cursosTableView: UITableView!
   
    func updateSearchResults(for searchController: UISearchController){
        if searchController.searchBar.text! == "" {
            datosFiltrados = cursos
        } else {
            datosFiltrados = cursos.filter{
                let s:String = $0.nombre
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))
            }
        }
        self.cursosTableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cursosTableView.delegate = self
        cursosTableView.dataSource = self

        // Do any additional setup after loading the view.
        cursoControlador.fetchCursos{ (resultado) in
            switch resultado{
            case .success(let listaCursos):self.updateGUI(listaCursos: listaCursos)
            case .failure(let error):self.displayError(e: error)
            }
           
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        cursosTableView.tableHeaderView = searchController.searchBar
    }
   
    func updateGUI(listaCursos: Cursos){
        DispatchQueue.main.async {
            self.cursos = listaCursos
            self.datosFiltrados = listaCursos
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
    func numberOfSections(in cursosTableView: UITableView) -> Int{
        return 1
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetalleCursoViewController
        let indice = self.cursosTableView.indexPathForSelectedRow?.row
        siguiente.curso = datosFiltrados[indice!]
    }
   

}



extension CursosViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cursosTableView.deselectRow(at: indexPath, animated: true)
    }
   
}

extension CursosViewController: UITableViewDataSource{
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
