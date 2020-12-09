//
//  ViewController.swift
//  MyProvinces
//
//  Created by Raul Olmedo on 8/12/20.
//

import UIKit

class ProvincesTableViewController: UITableViewController {
    // MARK: Properties
    let defaults = UserDefaults.standard
    var provinces = ["Albacete", "Alicante/Alacant", "Almería", "Araba/Álava", "Asturias", "Ávila", "Badajoz", "Balears, Illes", "Barcelona", "Bizkaia", "Burgos", "Cáceres", "Cádiz", "Cantabria", "Castellón/Castelló", "Ciudad Real", "Córdoba", "Coruña, A", "Cuenca", "Gipuzkoa", "Girona", "Granada", "Guadalajara", "Huelva", "Huesca", "Jaén", "León", "Lleida", "Lugo", "Madrid", "Málaga", "Murcia", "Navarra", "Ourense", "Palencia", "Palmas, Las", "Pontevedra", "Rioja, La", "Salamanca", "Santa Cruz de Tenerife", "Segovia", "Sevilla", "Soria", "Tarragona", "Teruel", "Toledo", "Valencia/València", "Valladolid", "Zamora", "Zaragoza", "Ceuta", "Melilla"]
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = editButtonItem

    }
    
    // MARK: Private
    func saveOnUserDefaults(key: String, value: String?) {
        defaults.set(value, forKey: key)
    }
    
    func readFromUserDefaults(key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    func deleteFromUserDefaults(key: String) {
        saveOnUserDefaults(key: key, value: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newProvince" {
            if let navigation = segue.destination as? UINavigationController {
                if let destination = navigation.viewControllers.first as? NewProvinceViewController {
                    destination.delegate = self
                    destination.title = "New Province"
                }
            }
            
            
        } else if segue.identifier == "showProvince" {
            if let destination = segue.destination as? ProvinceDetailViewController {
                if let selectedProvinceIndex = tableView.indexPathForSelectedRow?.row {
                    destination.provinceName = provinces[selectedProvinceIndex]
                    destination.delegate = self
                    destination.title = destination.provinceName
                    
                    if let data = self.readFromUserDefaults(key: provinces[selectedProvinceIndex]) {
                        destination.provinceInfo = data
                    }
                }
            }
        }
    }
    
    // MARK: - UITableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath)
        
        cell.textLabel?.text = provinces[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.provinces[sourceIndexPath.row]
        provinces.remove(at: sourceIndexPath.row)
        provinces.insert(movedObject, at: destinationIndexPath.row)
    }
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.deleteFromUserDefaults(key: self.provinces[indexPath.row])
            self.provinces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
                
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
    }
    
}

extension ProvincesTableViewController: ProvinceDetailViewControllerDelegate {
    func didTapSaveButton(data: String?) {
        if let provinceInformation = data {
            if let selectedProvinceIndex = tableView.indexPathForSelectedRow?.row {
                saveOnUserDefaults(key: provinces[selectedProvinceIndex], value: provinceInformation)
            }
        }
    }
}

extension ProvincesTableViewController: NewProvinceViewControllerDelegate {
    func didTapOnSaveButton(province: String) {
        provinces.append(province)
        tableView.reloadData()
    }
}
