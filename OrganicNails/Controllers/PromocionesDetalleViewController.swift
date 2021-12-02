//
//  PromocionesDetalleViewController.swift
//  OrganicNails
//
//  Created by user189966 on 11/5/21.
//

import UIKit
import FirebaseAuth

class PromocionesDetalleViewController: UIViewController {
    
    
    //Variables para los selects
    var presentacion = ["N/a"]
    var rowPrecio = 0
    
    //Variable que va a traer del otro lugar
    var producto:Producto?
    
    //Llamamos el controlador
    var productosControlador = ProductoControlador()
    var pedidoControlador = PedidoControlador()
    var usuarioControlador = ClienteControlador()
    
    
    //Variable a actualizar
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var presentacionProd: UITextField!
    @IBOutlet weak var ahorras: UILabel!
    
    
    //Creamos el pickerview
    var presentacionPickerView = UIPickerView()
    
    @IBAction func insertarPromocion(_ sender: UIButton) {
        let userUID = Auth.auth().currentUser!.uid
        print("usuario", userUID)
        var dataUsuario:[String:String] = [:]
        usuarioControlador.getUserDataForCreatingPedido(uid: userUID){
            (resultado) in
            switch resultado{
            case .success(let exito):dataUsuario = exito
                print(exito)
                var nuevoProducto = ProductoP(cantidad_producto: 1, color: self.producto!.colores[0], descripcion_producto: self.producto!.descripcion, descuento_producto: self.producto!.descuento, id_producto: self.producto!.id, nombre_producto: self.producto!.nombre, precio_producto: self.producto!.precio[self.rowPrecio], presentacion: self.presentacionProd.text!, tipo_producto: self.producto!.tipo, uso: self.producto!.uso, idDoc_producto: self.producto!.idDoc ?? "")
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                formatter.timeStyle = .full
                let datetime = formatter.string(from: now)
                     
                var nuevoPedido = Pedido(activo:true, estatus:"Pendiente",productos:[nuevoProducto], direccion: dataUsuario["direccion"]!, cursos:[], cliente_id:dataUsuario["id_doc"]!, fecha:datetime, uid: userUID)
                //print(nuevoPedido)
                // checar si hay carrito activo
                var pedidoId:String = ""
                //print("el id ",pedidoId)
                self.pedidoControlador.checarCarrito(){
                    (resultado) in
                    switch resultado{
                    case .success(let exito):pedidoId = exito
                    print("id del pedido activo", pedidoId)
                    if pedidoId.count != 0 {
                        //print("editar pedido")
                        self.pedidoControlador.agregarProductoEnPedido(nuevoProducto: nuevoProducto,idPedido: pedidoId){
                            (resultado) in
                            switch resultado{
                            case .success(let exito):self.displayExito(exito: exito)
                            case .failure(let error):self.displayError(e: error)
                            }
                        }
                    }else{
                        print("nuevo pedido")
                        self.pedidoControlador.crearPedidoConProductoP(nuevoPedido: nuevoPedido){
                            (resultado) in
                            switch resultado{
                            case .success(let exito):self.displayExito(exito: exito)
                            case .failure(let error):self.displayError(e: error)
                            }
                        }
                    }
                    case .failure(let error):self.displayError(e: error)
                    }}
            case .failure(let error):print("No se pudo encontrar la dirección error: ",error)
            }
         }
     }
    
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al añadir producto.", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func displayExito(exito:String){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Producto añadido", message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nombre.text? = producto?.nombre ?? ""
        presentacion = productosControlador.presentaciones(p: producto!)
        
        presentacionPickerView.delegate = self
        presentacionPickerView.dataSource = self
        
        //Damos las vistas a cada field
        presentacionProd.inputView = presentacionPickerView
        
        //Obtenemos tag
        presentacionPickerView.tag = 1
        
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

extension PromocionesDetalleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return presentacion.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return presentacion[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            rowPrecio = row
            presentacionProd.text = presentacion[row]
            presentacionProd.resignFirstResponder()
        
            //Cambiamos las demàs variables
            //Precio sin descuento
            var precioActual = String((producto?.precio[row])!)
            
            //Ahorras
            var precioActualInt = (producto?.precio[row])!
            var descuentoMult = Float(producto!.descuento / 100)
            var ahorrasDato = precioActualInt * descuentoMult
            
            //Precio con descuento
            var precioDescuento = precioActualInt - ahorrasDato
            
            //Para utilizarlas hacer lo siguiente:
            /*
             precioOriginal.text? = String(precioActual)
             descuendo.text? = String((producto?.descuento)!)
             precio.text? = String(precioDescuento)
             ahorras.text? = String(ahorrasDato)
             */
            
            precio.text? = precioActual
            ahorras.text? = String((producto?.descuento)!)+"%"
            
            
        default:
            return
        }
    }
}

