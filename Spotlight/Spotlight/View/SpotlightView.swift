//
//  SpotlightView.swift
//  Spotlight
//
//  Created by Jai Deep on 24/06/23.
//

import SwiftUI
import SDWebImageSwiftUI


struct SpotlightView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var spotlightViewModel: SpotlightViewModel = SpotlightViewModel()
    @State var itemArray: [Payload] = []
    @State var offset: CGFloat = 1000
    @State private var openAddProductView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ItemScrollView(spotlightViewModel: spotlightViewModel)
                
                NavigationLink(destination: AddProductsView().environmentObject(spotlightViewModel))  {
                    Image("AddProducts")
                        .padding(.bottom)
                        .padding(.trailing)
                }
                
                if !spotlightViewModel.selectedItems.isEmpty {
                    Button(action: {
                        let selectedItemsArray = Array(spotlightViewModel.selectedItems)
                        spotlightViewModel.deleteProducts(selectedItems: selectedItemsArray)
                    }) {
                        Rectangle()
                            .frame(height: 91)
                            .foregroundColor(Color(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)))
                            .transition(.move(edge: .bottom))
                            .overlay(
                                Button(action: {
                                    offset = 0
                                }) {
                                    Image("DeleteProducts")
                                        .frame(width: 163, height: 40)
                                }
                            )
                    }
                }
                
                DeleteDialogueBox(offset: $offset)
            }
            .onAppear {
                offset = 1000
                spotlightViewModel.getProductsIDs()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    spotlightViewModel.catalogBasic(catalogIDs: spotlightViewModel.featuredProductIDs)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            //            .navigationTitle("SpotLight")
        }
        .environmentObject(spotlightViewModel)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct DeleteDialogueBox: View {
    
    @Binding private var offset: CGFloat
    @EnvironmentObject var spotlightViewModel: SpotlightViewModel
    
    // Initialize the binding with a default value
    init(offset: Binding<CGFloat> = .constant(1000.0)) {
        _offset = offset
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                .foregroundColor(Color(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)))
                .shadow(radius: 24)
                .overlay(
                    VStack(spacing: 0) {
                        Text("Are you sure you want to remove these products from your store?")
                            .font(Font.custom("Signika", size: 24))
                            .fontWeight(.bold)
                            .padding(20)
                            .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        Text("Products that you remove from the store get removed permanently!")
                            .font(Font.custom("Urbanist", size: 14))
                            .kerning(0.2)
                            .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                            .frame(maxWidth: 300, alignment: .leading)
                            .padding(.bottom, 16)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                offset = 1000
                                deleteSelectedItems()
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 100, height: 44)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)), lineWidth: 1)
                                    )
                                    .overlay(
                                        Text("Delete")
                                            .font(Font.custom("Urbanist", size: 14))
                                            .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                                    )
                            }
                            
                            Spacer()
                            Spacer()
                            
                            Button(action: {
                                print("Cancel Pressed")
                                close()
                            }) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 100, height: 44)
                                    .foregroundColor(Color(UIColor(red: 0.98, green: 0.42, blue: 0.14, alpha: 1.00)))
                                    .overlay(
                                        Text("Cancel")
                                            .foregroundColor(.white)
                                            .font(Font.custom("Urbanist", size: 14))
                                    )
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                        .padding()
                )
                .offset(x: -15, y: offset-400)
        }
        .animation(.spring(), value: offset)
        .onAppear {
            withAnimation {
                offset = 1000
            }
        }
    }
    
    
    func deleteSelectedItems(){
        
        let deleteIDs = Array(spotlightViewModel.selectedItems)
        spotlightViewModel.deleteProducts(selectedItems: deleteIDs)
        spotlightViewModel.catalogs = []
        spotlightViewModel.selectedItems = []
        spotlightViewModel.getProductsIDs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            spotlightViewModel.catalogBasic(catalogIDs: spotlightViewModel.featuredProductIDs)
        }
    }
    
    func close() {
        withAnimation {
            offset = 1000
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightView()
    }
}




