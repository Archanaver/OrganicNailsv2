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
    
    var productos = [ProductoP]()
    var cursos = [CursoP]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productosTableVierw.delegate = self
        productosTableVierw.dataSource = self
        
        print("CURSOS", pedido?.cursos.count)
        print("PRODUCTOS", pedido?.productos.count)
        
        for i in pedido!.productos {
            productos.append(i)
        }
        
        for i in pedido!.cursos {
            cursos.append(i)
        }
 

        // Do any additional setup after loading the view.
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
