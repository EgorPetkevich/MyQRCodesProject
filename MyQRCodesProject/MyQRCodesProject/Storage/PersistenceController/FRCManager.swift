//
//  FRCManager.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//


import Foundation
import CoreData

final class FRCManager<DTO: DTODescription>:
    NSObject, NSFetchedResultsControllerDelegate {
    
    var didChangeContent: (([any DTODescription]) -> Void)?
    
    private let request: NSFetchRequest<DTO.MO> = {
        return NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
    }()
    
    private lazy var frc: NSFetchedResultsController<DTO.MO> = {
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistenceController.shared.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var fetchedTransferModels: [any DTODescription] {
        let dtos = frc.fetchedObjects?.compactMap { $0.toDTO() }
        return dtos ?? []
    }
    
    init(_ requestBuilder: (NSFetchRequest<DTO.MO>) -> Void ) {
        requestBuilder(self.request)
    }
    
    func startHandle() {
        try? frc.performFetch()
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? controller.performFetch()
        didChangeContent?(fetchedTransferModels)
    }
    
}
