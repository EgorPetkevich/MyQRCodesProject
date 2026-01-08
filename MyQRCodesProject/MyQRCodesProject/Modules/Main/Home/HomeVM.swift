//
//  HomeVM.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import Foundation
import Combine

final class HomeVM: ObservableObject {
    
    @Published var dtos: [any DTODescription] = []
    @Published var selectedDTO: (any DTODescription)?
    @Published var showDetails: Bool = false
    
    private var resetDtoIds: [String] = []
    
    private var storage: QRCodesFetchServiceProtocol
    
    private var bag: Set<AnyCancellable> = []
    
    init(storage: QRCodesFetchServiceProtocol) {
        self.storage = storage
    }
    
    func onAppear() {
        resetDtoIds = UDManager.getResentIds()
        fetchData()
    }
    
    private func fetchData() {
        storage.fetchAll()
            .map { dtos in
                dtos.filter {  self.resetDtoIds.contains($0.id)   }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dtos in
                self?.dtos = dtos
            }
            .store(in: &bag)
        $selectedDTO
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dto in
                guard let _ = dto else { return }
                self?.showDetails = true
            }
            .store(in: &bag)
    }
    
}
