//
//  ContactScanResultVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 4.01.26.
//

import SwiftUI

struct ContactScanResultVC: View {
    
    private enum Const {
        static let title: String = "Scan Result"
        static let actionButtonTitle: String = "Call"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: ContactScanResultVM

    
    init(viewModel: ContactScanResultVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            
            header
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 21) {
                    SuccessfulScanView()
                    resultView
                    
                    VStack(spacing: 13) {
                        ResultActionButton(
                            title: Const.actionButtonTitle,
                            icon: .init(systemName: "phone"),
                            fillGradient: .appSuccessButton,
                            didTap: { vm.actionButtonDidTap() }
                        )
                        
                        ResultBottomControls(
                            onCopy: { vm.copyButtonDidTap() },
                            onShare: { vm.shareDidTap() },
                            onSave: { vm.saveButtonDidTap() }
                        )
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 21)
            }
            .background(.appTextBorder)
            
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $vm.showShareSheet) {
            if let url = vm.shareURL {
                ActivityView(activityItems: [url])
            }
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {
                if vm.showCopiedToast {
                    ToastView(text: "Copied", icon: "doc.on.doc")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if vm.showSavedToast {
                    ToastView(text: "Saved", icon: "checkmark")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, 32)
            .animation(.easeInOut(duration: 0.25), value: vm.showCopiedToast)
            .animation(.easeInOut(duration: 0.25), value: vm.showSavedToast)
        }
  
    }
    
    private var header: some View {
        HStack {
            VStack {
                Spacer()
                Text(Const.title)
                    .inter(size: 22, style: .semiBold)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Button(action: { dismiss() }) {
                    ZStack {
                        Circle()
                            .fill(.appTextBorder)
                            .frame(width: 40, height: 40)
                        Image(.resultCross)
                            .size(9)
                    }
                }
                .padding(.bottom, 16)
                
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .background(Color.appPrimaryBg)
    }
    
    private var resultView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "phone")
                    .size(23)
                    .foregroundStyle(.appPrimaryBg)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.appAccentSuccess)
                            .frame(width: 48, height: 48)
                    )
                    .frame(width: 48, height: 48)
                    
                VStack(alignment: .leading, spacing: 4) {
                    Text("Contact")
                        .inter(size: 15, color: .appTextSecondary)
                    HStack() {
                        Text("First Name:")
                            .inter(size: 17, style: .semiBold)
                        Text(vm.contactDTO.firstName ?? "")
                            .inter(size: 17)
                    }
                    HStack() {
                        Text("Last Name:")
                            .inter(size: 17, style: .semiBold)
                        Text(vm.contactDTO.lastName ?? "")
                            .inter(size: 17)
                    }
                }
                
                Spacer()
            }
            
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                       Text("Full Content")
                           .inter(size: 15, color: .appTextSecondary)

                       if let address = vm.contactDTO.address {
                           infoRow(title: "Address", value: address)
                       }

                       if let phone = vm.contactDTO.phoneNumber {
                           infoRow(title: "Phone", value: phone)
                       }

                       if let workPhone = vm.contactDTO.phoneNumberWork {
                           infoRow(title: "Work Phone", value: workPhone)
                       }

                       if let email = vm.contactDTO.email {
                           infoRow(title: "Email", value: email)
                       }

                       if let organization = vm.contactDTO.organization {
                           infoRow(title: "Organization", value: organization)
                       }

                       if let jobTitle = vm.contactDTO.jobTitle {
                           infoRow(title: "Job Title", value: jobTitle)
                       }

                       if let birthday = vm.contactDTO.birthday {
                           infoRow(title: "Birthday", value: birthday.formattedBirthday())
                       }
                   }
                .padding(16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .roundedRectangleAsBackground(
                color: .appTextBorder,
                cornerRadius: 16
            )
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Scanned")
                        .inter(size: 13, color: .appTextSecondary)
                    Text(vm.contactDTO.createdAt.timeAgoString())
                        .inter(size: 15, style: .medium)
                }
                Spacer()

                VStack(alignment: .leading) {
                    Text("Type")
                        .inter(size: 13, color: .appTextSecondary)
                    Text("vCard")
                        .inter(size: 15, style: .medium)
                }
            }
            
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .roundedRectangleAsBackground(
            color: .appPrimaryBg,
            cornerRadius: 16
        )
        .setShadow(with: 16)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(title):")
                .inter(size: 17, style: .semiBold)
            Text(value)
                .inter(size: 17)
                .multilineTextAlignment(.leading)
        }
    }
    
}
