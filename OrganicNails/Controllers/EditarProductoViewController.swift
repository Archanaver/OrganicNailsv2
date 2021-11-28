//
//  EditarProductoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/19/21.
//

import UIKit
import FirebaseAuth


class EditarProductoViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var producto:ProductoP?
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
        let temp_oferta = (tempPrecio - ((Float((producto?.descuento_producto ?? 0))/100) * tempPrecio)) * Float(counter)
        oferta.text = String(temp_oferta)
    }
    
    
    @IBAction func disminuyeCantidad(_ sender: Any) {
        if counter > 0{
            counter -= 1
        }
        contadorCantidad.text = String(counter)
        precio.text = String(format: "%.2f", tempPrecio * Float(counter))
        let temp_oferta = (tempPrecio - ((Float((producto?.descuento_producto ?? 0))/100) * tempPrecio)) * Float(counter)
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
        
        presentacion.attributedPlaceholder = NSAttributedString(string: producto?.presentacion ?? "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        colores.attributedPlaceholder = NSAttributedString(string: producto?.color ?? "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        pickerPresentacion.tag = 1
        pickerColores.tag = 2
        pedidoControlador.fetchProducto(idProducto: producto?.idDoc_producto ?? ""){
            (resultado) in
            switch resultado{
            case .success(let exito):print(exito)
                self.datosPresentacion = exito.presentacion
                self.datosPrecio = exito.precio
                self.datosColores = exito.colores
                
            case .failure(let error):print(error)
               
            }
    }
        tempPrecio = producto?.precio_producto ?? 0
        nombreProducto.text = producto?.nombre_producto
        id.text = producto?.id_producto
        tipo.text = producto?.tipo_producto
        descripcion.text = producto?.descripcion_producto
        uso.text = producto?.uso
        tempDescuento = producto?.descuento_producto ?? 0
        if producto?.descuento_producto == 0{
            descuento.isHidden = true
            descuentoLabel.isHidden = true
            ofertaLabel.isHidden = true
            oferta.isHidden = true
        }else{
            descuento.text = String(tempDescuento)+" %"
            
        }
        contadorCantidad.text = String(producto?.cantidad_producto ?? 0)
        counter = producto?.cantidad_producto ?? 0
        precio.text = String(tempPrecio * Float(counter))
        let temp_of = (tempPrecio - ((Float((producto?.descuento_producto ?? 0))/100) * tempPrecio)) * Float(counter)
        oferta.text = String(temp_of)
    }

    
    @IBAction func guardarEdicion(_ sender: Any) {
        var idPedidoActivo = ""
        pedidoControlador.checarCarrito(){
            (resultado) in
            switch resultado{
            case .success(let exito): idPedidoActivo = exito
                var productoModificado = ProductoP(cantidad_producto: self.counter, color: self.tempColor, descripcion_producto: "", descuento_producto: 0, id_producto: "", nombre_producto: "", precio_producto: self.tempPrecio, presentacion: self.tempPresentacion, tipo_producto: "", uso: "", idDoc_producto: "")
                self.pedidoControlador.updateProducto(idPedido: idPedidoActivo, idProducto: self.producto?.idDoc ?? "", producto: productoModificado){
                    (resultado) in
                    switch resultado{
                    case .success(let exito): self.displayExito(titulo:"Producto modificado",exito:exito)
                    case .failure(let error): print(error)
                    
                    }}
            case .failure(let error):print(error)
            }
            
        }
    }
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
            let temp_oferta = (tempPrecio - ((Float((producto?.descuento_producto ?? 0))/100) * tempPrecio)) * Float(counter)
            
            oferta.text = String(temp_oferta)
            presentacion.resignFirstResponder()
        case 2:
            colores.text = datosColores[row]
            colores.resignFirstResponder()
        default:
            return
        }
        

        
    }
    
  
    
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al añadir producto.", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func displayExito(titulo:String, exito:String){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: titulo, message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }
        
    }
    
 
}
    


