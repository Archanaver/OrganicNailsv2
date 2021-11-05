//
//  EntregaViewController.swift
//  OrganicNails
//
//  Created by user189673 on 10/3/21.
//

import UIKit

class EntregaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func didTapButton(){
       guard let vc = storyboard?.instantiateViewController(identifier: "EvaluaServicio") as? EvaluaServicioViewController else {
        print("failed to load storyboard")
        return
}
        present(vc, animated: true)
    }
    @IBOutlet var button: UIButton!
    @IBAction func didTapButton2(){
       guard let vc = storyboard?.instantiateViewController(identifier: "ConfirmarUbicacion") as? ConfirmarPedidoViewController else {
        print("failed to load storyboard")
        return
}
        present(vc, animated: true)
    }

    

}
