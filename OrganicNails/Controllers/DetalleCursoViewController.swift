//
//  DetalleProductoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import UIKit
import FirebaseAuth

class DetalleCursoViewController: UIViewController {
    var curso:Curso?
    let pedidoControlador = PedidoControlador()
    let usuarioControlador = ClienteControlador()
    
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var codigo: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var precio: UILabel!

    @IBOutlet weak var descripcion: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text = curso?.nombre
        fecha.text = curso?.fecha
        instructor.text = curso?.instructor
        precio.text = String(format: "%.2f",curso?.precio ?? 0)
        descripcion.text = curso?.descripcion
        codigo.text = curso?.id
    }
    
    @IBAction func agregarCarrito( sender: UIButton){
        let userUID = Auth.auth().currentUser!.uid
        //print("usuario", userID)
        var dataUsuario:[String:String] = [:]
        usuarioControlador.getUserDataForCreatingPedido(uid: userUID){
            (resultado) in
                  switch resultado{
                  case .success(let exito):dataUsuario = exito
                      print(exito)
                    let nuevoCurso = CursoP(id_curso: self.codigo.text!, instructor: self.instructor.text!, nombre_curso: self.nombre.text!, precio_curso: self.precio.text!, fecha_curso: self.fecha.text!, descripcion_curso: self.descripcion.text!)
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.dateStyle = .full
                    formatter.timeStyle = .full
                    let datetime = formatter.string(from: now)
                    
                    let nuevoPedido = Pedido(activo:true, estatus:"Pendiente",productos:[], direccion: dataUsuario["direccion"]!, cursos:[nuevoCurso],cliente_id: dataUsuario["id_doc"]!, fecha: datetime, uid: userUID)
                    // checar si hay carrito activo
                    var pedidoId:String = ""
                    self.pedidoControlador.checarCarrito(){
                        (resultado) in
                        switch resultado{
                        case .success(let exito):pedidoId = exito
                            if pedidoId.count != 0 {
                                print("editar curso")
                                self.pedidoControlador.agregarCursoEnPedido(nuevoCurso: nuevoCurso, idPedido: pedidoId){
                                    (resultado) in
                                    switch resultado{
                                    case .success(let exito):self.displayExito(exito: exito)
                                    case .failure(let error):self.displayError(e: error)
                                    }
                                }
                                
                            }else{
                                print("nuevo curso")
                                self.pedidoControlador.crearPedidoConCursoP(nuevoPedido: nuevoPedido){
                                    (resultado) in
                                    switch resultado{
                                    case .success(let exito):self.displayExito(exito: exito)
                                    case .failure(let error):self.displayError(e: error)
                                    }
                                }
                                
                                
                            }
                        case .failure(let error):self.displayError(e: error)
                        }}
                    
                  case .failure(let error):print("No se pudo encontrar la direcci??n error; ",error)
                  }
            
           }
        
    }
    func displayExito(exito:String){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Curso a??adido", message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }
        
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al a??adir curso.", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
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
