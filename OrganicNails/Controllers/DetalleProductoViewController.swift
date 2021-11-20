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
    var tempDescuento:Int = 0
    
    let pedidoControlador = PedidoControlador()
    let usuarioControlador = ClienteControlador()
    
    @IBOutlet weak var descuentoLabel: UILabel!
    
    @IBOutlet weak var ofertaLabel: UILabel!
    @IBOutlet weak var nombreProducto: UILabel!
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var oferta: UILabel!
    @IBOutlet weak var contadorCantidad: UILabel!
    
    @IBAction func incrementaCantidad(_ sender: Any) {
        if counter < 10{
            counter += 1
        }
        contadorCantidad.text = String(counter)
        precio.text = String(format: "%.2f", tempPrecio * Float(counter))
        let temp_oferta = (tempPrecio - ((Float((producto?.descuento ?? 0))/100) * tempPrecio)) * Float(counter)
        oferta.text = String(temp_oferta)
    }
    
    
    @IBAction func disminuyeCantidad(_ sender: Any) {
        if counter > 0{
            counter -= 1
        }
        contadorCantidad.text = String(counter)
        precio.text = String(format: "%.2f", tempPrecio * Float(counter))
        let temp_oferta = (tempPrecio - ((Float((producto?.descuento ?? 0))/100) * tempPrecio)) * Float(counter)
        oferta.text = String(temp_oferta)
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
        
        tipo.text = producto?.tipo
        descripcion.text = producto?.descripcion
        uso.text = producto?.uso
        tempDescuento = producto?.descuento ?? 0
        if producto?.descuento == 0{
            descuento.isHidden = true
            descuentoLabel.isHidden = true
            ofertaLabel.isHidden = true
            oferta.isHidden = true
        }else{
            descuento.text = String(tempDescuento)+" %"
            
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
            let temp_oferta = (tempPrecio - ((Float((producto?.descuento ?? 0))/100) * tempPrecio)) * Float(counter)
            
            oferta.text = String(temp_oferta)
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
            let userUID = Auth.auth().currentUser!.uid
            print("usuario", userUID)
            var dataUsuario:[String:String] = [:]
            usuarioControlador.getUserDataForCreatingPedido(uid: userUID){
                (resultado) in
                switch resultado{
                case .success(let exito):dataUsuario = exito
                    print(exito)
                    var nuevoProducto = ProductoP(cantidad_producto: self.counter, color: self.tempColor, descripcion_producto: self.descripcion.text!, descuento_producto:self.tempDescuento, id_producto: self.id.text!, nombre_producto: self.nombreProducto.text!, precio_producto: self.tempPrecio, presentacion: self.tempPresentacion, tipo_producto: self.tipo.text!, uso: self.uso.text!, idDoc_producto: self.producto?.idDoc ?? "")
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
    

}


