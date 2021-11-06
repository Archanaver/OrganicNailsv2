//
//  PedidosViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/5/21.
//

import UIKit

class PedidosViewController: UIViewController {
    
    //Instanciamos la clase
    var pedidosControlador = PedidoControlador()
    
    //Creamos las variables
    var datos = [Pedido]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pedido: UITextField!

    
    //Variables para los selects
    let estado = ["Pendiente", "Entregado", "Todos"]
    
    //Creamos el pickerview
    var estadoPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        estadoPickerView.delegate = self
        estadoPickerView.dataSource = self
        
        //Damos las vistas a cada field
        pedido.inputView = estadoPickerView
        
        //Obtenemos tag
        estadoPickerView.tag = 1
        
        
        pedidosControlador.fetchPedidosEstado(estado: pedido.text!){ (result) in switch result {
        case .success(let pedidos):self.updateUI(with: pedidos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        pedidosControlador.fetchPedidosEstado(estado: pedido.text!){ (result) in switch result {
        case .success(let pedidos):self.updateUI(with: pedidos)
        case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
          }
        }
    }
    
    //Función de update
    func updateUI(with pedidos:Pedidos) {
        DispatchQueue.main.async {
            self.datos = pedidos
            
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
         let siguiente = segue.destination as! PromocionesDetalleViewController
         let indice =  self.tableView.indexPathForSelectedRow?.row
         siguiente.producto = datos[indice!]
 */
    }
    

}

extension PedidosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoCell", for: indexPath)
        cell.textLabel?.text = datos[indexPath.row].fecha
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PEDIDOS"
    }
    
    
}

extension PedidosViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return estado.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return estado[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            pedido.text = estado[row]
            pedido.resignFirstResponder()
            
            pedidosControlador.fetchPedidosEstado(estado: pedido.text!){ (result) in switch result {
            case .success(let pedidos):self.updateUI(with: pedidos)
            case .failure(let error):self.displayError(error, title: "No se pudo acceder a los productos")
              }
            }
            
        default:
            return
        }
    }
}

