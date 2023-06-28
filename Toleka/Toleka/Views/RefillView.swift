//
//  RefillView.swift
//  Toleka
//
//  Created by Cédric Bahirwe on 23/06/2023.
//

import SwiftUI

struct RefillView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var orderVM: OrderViewModel
    
    private let cylinderLayout = Array(repeating: GridItem(.flexible()), count: 5)
    private let quantityLayout = Array(repeating: GridItem(.flexible()), count: 7)
    private let brandLayout = Array(repeating: GridItem(.flexible()), count: 2)
    
    private let cylinders: [Double] = [6.0, 12.0, 15.0, 20.0, 25.0, 35.0, 38.0, 50.0]
    
    private let quantities: [Int] = (1...14).map({ $0 })
    
    private let gasBrands: [String] = ["MANJI GAS", "DAP GAS", "MIHAN GAS", "ABBARCI", "DEEP SKY", "ORYX", "KV GAS", "RWDA O02", "K-GAS", "TOTAL GAS", "SULFO GAS", "KIGALI GAS", "LAKE GAS", "BEST GAS", "OlL COM", "YES GAS", "METRO", "SP GAS", "CITY GAS", "S.E GAS", "HOYO", "SURAMBAYA", "MEREZ GAS", "SAFE GAS", "HASHI_EN", "MERU GAS"]


    @State private var selectedBrands = Set<String>()
    @State private var selectedQuantity: Int?
    @State private var selectedCylinder: Double?

    var body: some View {
        List {
            Section {
                LazyVGrid(columns: cylinderLayout,
                          pinnedViews: .sectionHeaders) {
                    ForEach(cylinders, id: \.self) { cylinder in
                        CircleButton(title: String(cylinder),
                                     subtitle: "Kgs",
                                     isSelected: selectedCylinder == cylinder)
                        .onTapGesture {
                            withAnimation {
                                if selectedCylinder == cylinder {
                                    selectedCylinder = nil
                                }else {
                                    selectedCylinder = cylinder
                                }
                            }
                        }
                    }
                }
            } header: {
                Text("Cylinder Size(Kgs)")
                    .textCase(nil)
                    .font(.headline)
                    .padding(.vertical, 10)
            }

            Section {
                LazyVGrid(
                    columns: quantityLayout,
                    pinnedViews: .sectionHeaders) {
                        ForEach(quantities, id: \.self) { quantity in
                            CircleButton(title: String(quantity),
                                         isSelected: quantity == selectedQuantity)
                            .onTapGesture {
                                withAnimation {
                                    if selectedQuantity == quantity {
                                        selectedQuantity = nil
                                    }else {
                                        selectedQuantity = quantity
                                    }
                                }
                            }
                        }
                    }
                    .background(.background)
                    .cornerRadius(12)

            } header: {
                Text("Quantity")
                    .textCase(nil)
                    .font(.headline)
                    .padding(.vertical, 10)
            }
            

            Section {
                LazyVGrid(
                    columns: brandLayout,
                    alignment: .leading,
                    spacing: 20,
                    pinnedViews: .sectionHeaders) {
                        ForEach(gasBrands, id: \.self) { brandName in
                            LabeledCheckBox(title: brandName,
                                            isSelected: selectedBrands.contains(brandName))
                            .onTapGesture {
                                withAnimation {
                                    if selectedBrands.contains(brandName) {
                                        selectedBrands.remove(brandName)
                                    }else {
                                        selectedBrands.insert(brandName)
                                    }
                                }
                            }
                        }
                    }
                    .background(.background)
                    .cornerRadius(12)

            } header: {
                Text("Brand/Company")
                    .textCase(nil)
                    .font(.headline)
                    .padding(.vertical, 10)
            }
            
        }
        .listStyle(.insetGrouped)
        .background(Color(.secondarySystemBackground))
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading) {
                Text("Total: \(0) USD")
                    .font(.title3)
                HStack {
                    LargeButton("Order Now",
                                tint: colorScheme == .light ? .black : .white,
                                foreground: colorScheme == .light ? .white : .black,
                                action: { })
                    
                    LargeButton("Add To Cart", action: {})
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .toolbar {
            CartButton(count: orderVM.getCartCount())
        }
        .navigationTitle("New Purchase")
    }
}

struct RefillView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RefillView(orderVM: OrderViewModel())
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct LabeledCheckBox: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 25) {
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .imageScale(.large)
                .foregroundColor(isSelected ? Color.accentColor : Color(.darkGray))
            
            Text(title)
                .foregroundColor(Color(.darkGray))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


private struct CircleButton: View {
    let title: String
    var subtitle: String?
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
            if let subtitle {
                Text(subtitle)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color.accentColor : .clear)
        .clipShape(Circle())
        .overlay {
            Circle().strokeBorder(isSelected ? Color.accentColor : Color(.darkGray), lineWidth: 1)
        }
        .foregroundColor(isSelected ? .white : .primary)
    }
}
