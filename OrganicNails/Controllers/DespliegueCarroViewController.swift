//
//  PedidosDetalleViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/7/21.
//

import UIKit

class DespliegueCarroViewController: UIViewController {
    
    //Variable que va a traer del otro lugar
    var pedido:Pedido?
    
    @IBOutlet weak var CarritoTableView: UITableView!
    
    @IBOutlet weak var Total: UILabel!

    var productos = [ProductoP]()
    var cursos = [CursoP]()
    

    override func viewDidLoad() {
        func viewDidLoad() {
            super.viewDidLoad()
            
            CarritoTableView.delegate = self
            CarritoTableView.dataSource = self
            
            print("CURSOS", pedido?.cursos!.count)
            print("PRODUCTOS", pedido?.productos!.count)
            
            for i in pedido!.productos! {
                productos.append(i)
            }
            
            for i in pedido!.cursos! {
                cursos.append(i)
            }
     

           
        }
        

       

    }
}

    extension DespliegueCarroViewController: UITableViewDelegate, UITableViewDataSource {
        
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
                cell.textLabel?.text = cursos[indexPath.row].NombreCurso()
                return cell
            }
            else {
                cell.textLabel?.text = productos[indexPath.row].NombreProducto()
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


