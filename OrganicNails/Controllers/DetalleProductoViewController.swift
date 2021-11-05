//
//  DetalleProductoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import UIKit
import FirebaseAuth

class DetalleProductoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    
    var producto:Producto?
    var tempPrecio: Float = 0.0
    var counter = 0
    var datosPresentacion:[String] = []
    var datosPrecio:[Float] = []
    var datosColores:[String] = []
    var tempPresentacion:String = ""
    var tempColor:String = ""
    
    let pedidoControlador = PedidoControlador()
    let usuarioControlador = UsuarioControlador()
    
    
    @IBOutlet weak var nombreProducto: UILabel!
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var contadorCantidad: UILabel!
    
    @IBAction func incrementaCantidad(_ sender: Any) {
        if counter < 10{
            counter += 1
        }
        contadorCantidad.text = String(counter)
        precio.text = String(format: "%.2f", tempPrecio * Float(counter))
    }
    
    
    @IBAction func disminuyeCantidad(_ sender: Any) {
        if counter > 0{
            counter -= 1
        }
        contadorCantidad.text = String(counter)
        precio.text = String(format: "%.2f", tempPrecio * Float(counter))
    }
    
    @IBOutlet weak var presentacion: UITextField!
    
    @IBOutlet weak var colores: UITextField!
    
    @IBOutlet weak var precio: UILabel!
    
    @IBOutlet weak var descuento: UILabel!
    
    
 
    
    @IBOutlet weak var descripcion: UITextView!
    
    @IBOutlet weak var uso: UITextView!
    @IBOutlet weak var tipo: UILabel!

    
    var pickerPresentacion = UIPickerView()
    var pickerColores = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerPresentacion.delegate = self
        pickerPresentacion.dataSource = self
        pickerColores.delegate = self
        pickerColores.dataSource = self
        
        presentacion.inputView = pickerPresentacion
        presentacion.textAlignment = .center
        colores.inputView = pickerColores
        colores.textAlignment = .center
        
        presentacion.placeholder = "Selecciona presentación"
        colores.placeholder = "Selecciona color"
        
        pickerPresentacion.tag = 1
        pickerColores.tag = 2
        
        
        
        datosPresentacion = producto?.presentacion ?? []
        datosPrecio = producto?.precio ?? []
        datosColores = producto?.colores ?? []
        
        nombreProducto.text = producto?.nombre
        id.text = producto?.id
        descuento.text = String(format: "%.2f",producto?.descuento ?? 0)
        tipo.text = producto?.tipo
        descripcion.text = producto?.descripcion
        uso.text = producto?.uso
        


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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return datosPresentacion.count
        case 2:
            return datosColores.count
        default:
            return 1
        }
         
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int )-> String?{
        switch pickerView.tag {
        case 1:
            tempPresentacion = datosPresentacion[row]
            return datosPresentacion[row]
        case 2:
            tempColor = datosColores[row]
            return datosColores[row]
        default:
            return "Dato no encontrado"
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView.tag {
        case 1:
            presentacion.text = datosPresentacion[row]
            if counter == 0 {
                counter += 1
            }
            tempPrecio = datosPrecio[row]
            precio.text = String(format: "%.2f", tempPrecio * Float(counter))
            contadorCantidad.text = String(counter)
            presentacion.resignFirstResponder()
        case 2:
            colores.text = datosColores[row]
            colores.resignFirstResponder()
        default:
            return
        }
        

        
    }
    
    @IBAction func insertarPedido( sender: UIButton){
        
        if (presentacion.text == "" || colores.text == ""){
            let alerta =  UIAlertController(title: "Campos faltantes", message: "Favor de llenar los campos faltantes", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }else{
            let userID = Auth.auth().currentUser!.uid
            //print("usuario", userID)
            var direccionUsuario:String = ""
               usuarioControlador.getDireccionUsuario(uid: userID){
                      (resultado) in
                      switch resultado{
                      case .success(let exito):direccionUsuario=self.getDireccion(exito: exito)
                        //print("usuario dirección", direccionUsuario)
                        var nuevoProducto = ProductoP(cantidad_producto: self.counter, color: self.tempColor, descripcion_producto: self.descripcion.text!, descuento_producto: (self.descuento.text! as NSString).floatValue, id_producto: self.id.text!, nombre_producto: self.nombreProducto.text!, precio_producto: self.tempPrecio, presentacion: self.tempPresentacion, tipo_producto: self.tipo.text!, uso: self.uso.text!)
                        
                        var nuevoPedido = Pedido(activo:true, estatus:"Pendiente",productos:[nuevoProducto], direccion: direccionUsuario)
                        
                        // checar si hay carrito activo
                        var pedidoId:String = ""
                        //print("el id antes",pedidoId)
                        self.pedidoControlador.checarCarritoActivo(){
                            (resultado) in
                            switch resultado{
                            case .success(let exito):pedidoId = self.displayExitoCarrito(exito: exito)
                                if pedidoId.count != 0 {
                                    //print("editar pedido")
                                    self.pedidoControlador.agregarPedidoProducto(nuevoProducto: nuevoProducto,idPedido: pedidoId){
                                        (resultado) in
                                        switch resultado{
                                        case .success(let exito):self.displayExito(exito: exito)
                                        case .failure(let error):self.displayError(e: error)
                                        }
                                    }
                                }else{
                                    //print("nuevo pedido")
                                    self.pedidoControlador.crearPedidoConProducto(nuevoPedido: nuevoPedido){
                                            (resultado) in
                                            switch resultado{
                                            case .success(let exito):self.displayExito(exito: exito)
                                            case .failure(let error):self.displayError(e: error)
                                            }
                                        }
                                }
                            case .failure(let error):self.displayError(e: error)
                            }
                        }
                      case .failure(let error):print("No se pudo encontrar la dirección, error; ",error)
                      }
                  }
           

        }



        //print(nuevoPedido)

        

        
    /*    pedidoControlador.updatePedidoProducto(nuevoProducto: nuevoProducto, idPedido: pedidoControlador.checarCarritoActivo()){
              (resultado) in
              switch resultado{
              case .success(let exito):self.displayExito(exito: exito)
              case .failure(let error):self.displayError(e: error)
              }
          }
        */
        

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
    
    func displayExitoCarrito(exito:String)->String{
        DispatchQueue.main.async {
        }
        return exito
    }
    
    func getDireccion(exito:String)->String{
        DispatchQueue.main.async {
        }
        return exito
    }

}


