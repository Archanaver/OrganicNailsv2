//
//  DireccionEnvioViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/23/21.
//

import UIKit
import MapKit
import CoreLocation

class DireccionEnvioViewController: UIViewController {
    var total:Float = 0
    var ahorro:Float = 0
    var envio:Float = 0

    @IBOutlet weak var dir: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        LocationControlador.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    func addMapPin(with location: CLLocation){
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map .setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotation(pin)
        LocationControlador.shared.resolveLocationName(with: location) { [weak self] locationName in
            
            self!.dir.text = locationName
            
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let siguiente = segue.destination as! DetallePedidoViewController
        siguiente.ahorro = ahorro
        siguiente.total = total
    }
    
 

}
