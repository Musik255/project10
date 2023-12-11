//
//  ViewController.swift
//  Project10
//
//  Created by Павел Чвыров on 11.12.2023.
//

import UIKit

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people : [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPersonAlert)
        )
        navigationItem.leftBarButtonItem = addButton
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.nameLabel.text = person.name
        
        let path = Bundle.documentsDirectory.appending(path: person.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        if person.name == Person.defaultName{
            renameAlert(for: person)
        }
        else{
            
        }
        
    }
    
    @objc func addNewPersonAlert(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    
    @objc func renameAlert(for person : Person){
        
        let alertController = UIAlertController(
            title: "Rename person",
            message: "Enter new name for image",
            preferredStyle: .actionSheet)
        
        
        alertController.addTextField()
        
        
        alertController.addAction(
            UIAlertAction(title: "Ok", style: .default)
            { [weak self, weak alertController] _ in
                guard let newName = alertController?.textFields?[0].text else { return }
                person.name = newName
                
                self?.collectionView.reloadData()
                
            }
        )
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    
    @objc func renameDeleteAlert(for person : Person){
        
        let alertController = UIAlertController(
            title: "Selected \(person.name)",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(
            UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                self?.renameAlert(for: person)
            }
        )
        
        alertController.addAction(
            UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            
                guard let firstIndexPerson = self?.people.firstIndex(of: person) else { return }
                
                self?.people.remove(at: firstIndexPerson)
                self?.collectionView.reloadData()
                
            }
        )
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Bundle.documentsDirectory.appending(path: imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }

    
                                  
                                
    

    func getDocumentDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}

