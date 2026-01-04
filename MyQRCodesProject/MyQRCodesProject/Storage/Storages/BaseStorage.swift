//
//  BaseStorage.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import Foundation
import Combine
import CoreData

class BaseStorage<DTO: DTODescription> {
    
    init() { }
    
    func fetch() -> AnyPublisher<[any DTODescription], Never> {
        let context = PersistenceController.shared.container.viewContext
        let result = fetchMO(
            sortDescriptors: [.byDate()],
            context: context
        ).compactMap {
            $0.toDTO()
        }
        return Just(result).eraseToAnyPublisher()
        
    }
    
    func fetchSingle(by id: String) -> AnyPublisher<(any DTODescription)?, Never> {
        let context = PersistenceController.shared.container.viewContext
        guard let mo = fetchMOSingle(
            by: id,
            context: context
        )
        else { return Just(nil).eraseToAnyPublisher() }
        return Just(
            mo.toDTO()
        ).eraseToAnyPublisher()
    }
    

    func save(dto: DTO) -> AnyPublisher<Void, StorageError> {
        Future { [weak self] promise in
            guard let self else { return }
            Task.detached {
                do {
                    let ctx = PersistenceController.shared.container.viewContext

                    let existing = self.fetchMOSingle(by: dto.id, context: ctx)
                    guard let mo = existing ?? dto.createMO(context: ctx) else { return }

                    mo.apply(dto: dto)

                    if existing == nil {
                        ctx.insert(mo)
                    }

                    try ctx.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(.cannotSave))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Void, StorageError> {
        Future { [weak self] promise in
            guard let self else { return }
            Task.detached {
                do {
                    let context = PersistenceController.shared.container.viewContext
                    if let mo = self.fetchMOSingle(by: id, context: context) {
                        context.delete(mo)
                        try context.save()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(.cannotDelete))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    
    func fetch(predicate: NSPredicate? = nil,
               sortDescriptors: [NSSortDescriptor] = []
    ) -> [any DTODescription] {
        let context = PersistenceController.shared.container.viewContext
        return fetchMO(predicate: predicate,
                       sortDescriptors: sortDescriptors,
                       context: context)
        .compactMap { $0.toDTO() }
    }

    private func fetchMO(predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor] = [],
                 context: NSManagedObjectContext)
    -> [DTO.MO] {
        let request = NSFetchRequest<DTO.MO>(entityName: "\(DTO.MO.self)")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let results = try? context.fetch(request)
        return results ?? []
    }
    
    func fetchMOSingle(
        by id: String,
        context: NSManagedObjectContext
    ) -> DTO.MO? {
        return fetchMO(
            predicate: .byId(id),
            context: context).first
    }
    
}
