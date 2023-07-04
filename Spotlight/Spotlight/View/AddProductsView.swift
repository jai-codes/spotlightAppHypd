//
//  AddProductsView.swift
//  Spotlight
//
//  Created by Jai Deep on 28/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddProductsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var addProductsViewModel: AddProductsViewModel = AddProductsViewModel()
    @EnvironmentObject var spotlightViewModel: SpotlightViewModel
    
    
    @State private var selectedTab: Tab = .category
    @State private var isShowingBottomSheet = false
    @State private var showMaxProductMessage = false
    
    enum Tab {
        case category
        case brands
        case products
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                ZStack {
                    Text("Category")
                        .font(
                            Font.custom("Urbanist", size: 16)
                                .weight(.medium)
                        )
                        .kerning(0.2)
                        .foregroundColor(selectedTab == .category ? Color(red: 0.07, green: 0.08, blue: 0.11) : Color(red: 0.36, green: 0.36, blue: 0.36))
                        .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .foregroundColor(selectedTab == .category ? Color(red: 0.07, green: 0.08, blue: 0.11) : .clear)
                        .frame(height: 2)
                        .offset(y: 21) 
                }
                .onTapGesture {
                    selectedTab = .category
                    
                }
                
                ZStack {
                    Text("Brands")
                        .font(
                            Font.custom("Urbanist", size: 16)
                                .weight(.medium)
                        )
                        .kerning(0.2)
                        .foregroundColor(selectedTab == .brands ? Color(red: 0.07, green: 0.08, blue: 0.11) : Color(red: 0.36, green: 0.36, blue: 0.36))
                        .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .foregroundColor(selectedTab == .brands ? Color(red: 0.07, green: 0.08, blue: 0.11) : .clear)
                        .frame(height: 2)
                        .offset(y: 21) 
                }
                .onTapGesture {
                    selectedTab = .brands
                    DispatchQueue.main.async {
                        addProductsViewModel.brandBasic(brandIDs: addProductsViewModel.hotSellingBrandsIDs)
                    }
                    
                }
                
                ZStack {
                    Text("Products")
                        .font(
                            Font.custom("Urbanist", size: 16)
                                .weight(.medium)
                        )
                        .kerning(0.2)
                        .foregroundColor(selectedTab == .products ? Color(red: 0.07, green: 0.08, blue: 0.11) : Color(red: 0.36, green: 0.36, blue: 0.36))
                        .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .foregroundColor(selectedTab == .products ? Color(red: 0.07, green: 0.08, blue: 0.11) : .clear)
                        .frame(height: 2)
                        .offset(y: 21) 
                }
                .onTapGesture {
                    selectedTab = .products
                    DispatchQueue.main.async {
                        addProductsViewModel.getHotSellingCatalogs(catalogIDs: addProductsViewModel.hotSellingCatalogIDs)
                    }
                    
                }
            }
            .padding(.bottom)
            
            ScrollView (showsIndicators: false){
                if selectedTab == .category {
                    CategoryView()
                } else if selectedTab == .brands {
                    BrandsView()
                } else {
                    ProductsView()
                }
            }
            Rectangle()
                .frame(height: 54)
                .foregroundColor(Color(UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)))
                .transition(.move(edge: .bottom))
                .overlay(
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 38, height: 38)
                            .background(Color(red: 0.2, green: 0.15, blue: 0.27))
                            .cornerRadius(38)
                            .overlay(
                                Text("\(addProductsViewModel.addedItems.count)")
                                    .font(
                                        Font.custom("Urbanist", size: 16)
                                            .weight(.bold)
                                    )
                                    .kerning(0.2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            )
                        VStack {
                            Text("Added Products")
                                .font(
                                    Font.custom("Urbanist", size: 13)
                                        .weight(.bold)
                                )
                                .kerning(0.4)
                                .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                                .frame(width: 103, height: 18, alignment: .topLeading)
                            
                            
                            
                            Text("View Products")
                                .font(
                                    Font.custom("Urbanist", size: 11)
                                        .weight(.medium)
                                )
                                .kerning(0.4)
                                .foregroundColor(Color(red: 0.28, green: 0.57, blue: 1))
                            
                            // Commented the bottomsheet on tap of View Products as when it is closed it is taking to homescreen need to check it
//                                .onTapGesture {
//                                    spotlightViewModel.catalogBasic(catalogIDs: Array(addProductsViewModel.addedItems))
//                                    isShowingBottomSheet = true
//                                }
//
//                                .sheet(isPresented: $isShowingBottomSheet) {
//                                    BottomSheetView(isShowingBottomSheet: $isShowingBottomSheet)
//                                }
                            
                        }
                        Spacer()
                        Rectangle()
                            .frame(width:148, height: 44)
                            .cornerRadius(12)
                            .foregroundColor(Color(UIColor(red: 0.98, green: 0.42, blue: 0.14, alpha: 1.00)))
                            .overlay(
                                Button(action: {
                                    if addProductsViewModel.addedItems.count <= 20 {
                                        // Perform the action to add the product
                                        print(addProductsViewModel.addedItems)
                                        DispatchQueue.main.async {
                                            DispatchQueue.main.async {
                                                addProductsViewModel.AddProducts(addedProducts: Array(addProductsViewModel.addedItems))
                                            }
                                            
                                        }
                                        spotlightViewModel.catalogs = []
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                        
                                    } else {
                                        // Set the state to show the message
                                        showMaxProductMessage.toggle()
                                    }
                                }, label: {
                                    Text("Add to Store")
                                        .font(
                                            Font.custom("Urbanist", size: 14)
                                                .weight(.bold)
                                        )
                                        .kerning(0.2)
                                        .foregroundColor(.white)
                                })
                            )
                        
                    }
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.horizontal)
                )
            
            Spacer()
        }
        .onAppear{
            let featuredProductIDsArray = spotlightViewModel.featuredProductIDs // Access the value published by the property
            let featuredProductIDsSet = Set(featuredProductIDsArray)
            addProductsViewModel.addedItems = featuredProductIDsSet
            
            DispatchQueue.main.async {
                addProductsViewModel.getHotSellingCatalogIDs()
                addProductsViewModel.getHotSellingBrandIDs()
            }
        }
        .padding()
        .environmentObject(spotlightViewModel)
        .environmentObject(addProductsViewModel)
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $showMaxProductMessage) {
            Alert(
                title: Text("Maximum Product Count Exceeded"),
                message: Text("Cannot add more than 20 products."),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                HStack{
            Button(action:{
                presentationMode.wrappedValue.dismiss()
            }){
                Image("BackArrow")
                    .resizable()
                    .frame(width:24, height:24)
                    .foregroundColor(.black)
            }
            .padding(.leading, 16)
            Text("Add Products")
                .foregroundColor(.black)
                .font(.custom("Urbanist-Medium", size: 16))
                .tracking(0.2)
            Spacer()
        })
    }
    
}

// MARK: Category Page

struct CategoryView: View {
    
    // dummy data
    var categoryNames = ["Health", "Fitness", "Men", "Women", "Food & Beverages", "Footwear"]
    var subCategories = ["Supplements", "Equipments", "Steroids"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(categoryNames, id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category)
                        .font(Font.custom("Urbanist", size: 16).weight(.medium))
                        .kerning(0.2)
                        .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                    //                            .padding()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 163))]) {
                        ForEach(subCategories, id: \.self) { subcategories in
                            ZStack {
                                Image("batman")
                                    .resizable()
                                    .frame(height: 160)
                                    .shadow(radius: 20)
                                    .cornerRadius(20)
                                Text(subcategories)
                                    .font(Font.custom("Urbanist", size: 14).weight(.medium))
                                    .kerning(0.2)
                                    .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                            }
                        }
                    }
                }
            }
        }
        // API Yet to be integrated for categories
        //        ForEach
        //        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
        //            ForEach(subCategories, id: \.self) { l2Categories in
        //
        //                ZStack (alignment: .bottom){
        //                    Image("batman")
        //                            .resizable()
        //                            .aspectRatio(contentMode: .fit)
        //                            .frame(width:163, height: 163)
        //                            .cornerRadius(16)
        //                    Text("\(l2Categories)")
        //                      .font(Font.custom("Signika", size: 18)
        //                          .weight(.bold))
        //                      .foregroundColor(.white)
        //                      .frame(width: 131, height: 23, alignment: .bottomLeading)
        //
        //                }
        //
        //                }
        //
        //        }
    }
    
}

// MARK: Brand Page

struct BrandsView: View {
    
    @EnvironmentObject var addProductsViewModel: AddProductsViewModel
    
    var brands = ["Puma", "Reebok", "Nike", "Adidas", "Asics", "Skechers", "Underarmor"]
    var subBrands = ["#", "A", "Nike1", "Adidas1", "Asics1", "Skechers1", "Underarmor1"]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Brands")
                .font(
                    Font.custom("Signika", size: 21)
                        .weight(.bold)
                )
                .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Popular Brand horizontal scroll view
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 140))], spacing: 16) {
                    ForEach(addProductsViewModel.hotSellingBrands, id: \.self) { brand in
                        VStack(alignment: .center) {
                            WebImage(url: URL(string: brand.logo.src ?? ""))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 86, height: 86)
                                .clipped()
                                .cornerRadius(100)
                                .onTapGesture {
                                    DispatchQueue.main.async {
                                        addProductsViewModel.brhamastra(l2Category: "", brandId: brand.id)
                                    }
                                }
                            
                            Text(brand.name)
                                .font(
                                    Font.custom("Urbanist", size: 14)
                                        .weight(.medium)
                                )
                                .kerning(0.2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                                .frame(width: 85, height: 20, alignment: .top)
                        }
                    }
                }
            }.ignoresSafeArea(.all)
            
            // Sorted brand List
            VStack(alignment: .leading, spacing: 15) {
                ForEach(subBrands, id: \.self) { subBrand in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subBrand)
                            .font(Font.custom("Urbanist", size: 16).weight(.medium))
                            .kerning(0.2)
                            .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                        //                            .padding()
                        
                        ForEach(brands, id: \.self) { brand in
                            HStack {
                                Image("batman")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 20)
                                    .cornerRadius(20)
                                Text(brand)
                                    .font(Font.custom("Urbanist", size: 14).weight(.medium))
                                    .kerning(0.2)
                                    .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

// MARK: Product Page

struct ProductsView: View {
    //    @EnvironmentObject var spotlightViewModel: SpotlightViewModel
    @EnvironmentObject var addProductsViewModel: AddProductsViewModel
    
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 20)], spacing: 16) {
                ForEach(Array(addProductsViewModel.hotSellingCatalogs), id: \.id) { catalog in
                    CatalogView(catalog: catalog)
                }
            }
        }
    }
    
    @ViewBuilder
    private func CatalogView(catalog: Payload) -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                WebImage(url: URL(string: catalog.featured_image.src))
                    .resizable()
                    .frame(width: 164.5, height: 215.52)
                    .cornerRadius(12)
                    .offset(x: 0)
                
                Text(catalog.brand_info.name
                    .split(separator: " ")
                    .prefix(2)
                    .joined(separator: " ")
                     + (catalog.brand_info.name.count > 13 ? "..." : ""))
                .font(Font.custom("Urbanist", size: 12))
                .fontWeight(.heavy)
                .lineSpacing(4)
                .lineLimit(1)
                .kerning(0.4)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                
                Text(catalog.name)
                    .font(Font.custom("Urbanist", size: 12).weight(.medium))
                    .fontWeight(.medium)
                    .frame(width: 155, height: 32, alignment: .leading)
                    .foregroundColor(Color(UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)))
                    .kerning(0.4)
                    .lineLimit(2)
                
                if catalog.retail_price.value == catalog.base_price.value {
                    Text("₹\(catalog.retail_price.value)")
                        .font(.custom("Urbanist", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .lineLimit(1)
                } else {
                    DiscountedPriceView(catalog: catalog)
                }
                
                Rectangle()
                    .fill(Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)))
                    .frame(width: 170, height: 24)
                    .cornerRadius(6)
                    .overlay(
                        HStack {
                            Image("commissionIcon")
                                .font(.system(size: 12))
                                .frame(alignment: .leading)
                            
                            Text("Commission")
                                .font(.custom("Urbanist", size: 12))
                                .frame(height: 16)
                                .fontWeight(.bold)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            Text("\(catalog.commission_rate)%")
                                .font(.custom("Urbanist", size: 12))
                                .fontWeight(.bold)
                        }
                            .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                    )
                    .padding(.vertical)
            }
            
            Button(action: {
                if addProductsViewModel.addedItems.contains(catalog.id) {
                    addProductsViewModel.addedItems.remove(catalog.id)
                } else {
                    addProductsViewModel.addedItems.insert(catalog.id)
                }
            }) {
                Image(addProductsViewModel.addedItems.contains(catalog.id) ? "SelectedIcon" : "AddProductsIcon")
            }
            .padding(.bottom, 130)
            .padding(.trailing,20)
            .padding(.leading, 8)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
    
    private func selectItem(_ id: String) {
        if addProductsViewModel.addedItems.contains(id) {
            addProductsViewModel.addedItems.remove(id)
        } else {
            addProductsViewModel.addedItems.insert(id)
        }
    }
    
    @ViewBuilder
    private func DiscountedPriceView(catalog: Payload) -> some View {
        let discount = catalog.base_price.value - catalog.retail_price.value
        let discountPercentage = Double(discount) / Double(catalog.base_price.value) * 100
        
        HStack(spacing: 4) {
            Text("₹\(catalog.retail_price.value)")
                .font(.custom("Urbanist", size: 14))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(alignment: .leading)
                .lineLimit(1)
            
            Text("₹\(catalog.base_price.value)")
                .font(.custom("Urbanist", size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)))
                .strikethrough(true, color: (Color(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00))))
                .lineLimit(1)
            
            Text("(\(Int(discountPercentage.rounded()))% off)")
                .font(
                    Font.custom("Urbanist", size: 12)
                        .weight(.bold)
                )
                .kerning(0.4)
                .foregroundColor(Color(red: 0, green: 0.76, blue: 0.35))
        }
    }
    
}


// MARK: BOTTOM SHEET VIEW

struct BottomSheetView: View {
    
    @Binding var isShowingBottomSheet: Bool
    //    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var spotlightViewModel: SpotlightViewModel
    @EnvironmentObject var addProductsViewModel: AddProductsViewModel
    
    var body: some View {
        VStack {
            Text("Added Products")
                .font(Font.custom("Urbanist", size: 16).weight(.medium))
                .kerning(0.2)
                .foregroundColor(.black)
                .padding()
            
            ScrollView (showsIndicators: false){
                LazyVStack(spacing: 0) {
                    ForEach(spotlightViewModel.catalogs) { catalog in
                        VStack(spacing: 0) {
                            HStack {
                                WebImage(url: URL(string: catalog.featured_image.src))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 73, height: 105.79708)
                                    .cornerRadius(12)
                                    .offset(y: 16)
                                
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(catalog.brand_info.name)
                                        .font(Font.custom("Urbanist", size: 12).weight(.bold))
                                        .kerning(0.4)
                                        .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                                    
                                    Text(catalog.name)
                                        .font(Font.custom("Urbanist", size: 12).weight(.medium))
                                        .lineLimit(2)
                                        .kerning(0.4)
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                        .frame(width: 185, height: 16, alignment: .topLeading)
                                    
                                    if catalog.base_price.value == catalog.retail_price.value{
                                        Text("₹\(catalog.base_price.value)")
                                            .font(.custom("Urbanist", size: 14))
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .frame(alignment: .leading)
                                            .lineLimit(1)
                                    }else{
                                        
                                        let discount = catalog.base_price.value - catalog.retail_price.value
                                        let discountPercentage = Double(discount) / Double(catalog.base_price.value) * 100
                                        HStack(spacing: 4) {
                                            Text("₹\(catalog.retail_price.value)")
                                                .font(.custom("Urbanist", size: 14))
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                                .frame(alignment: .leading)
                                                .lineLimit(1)
                                            
                                            Text("₹\(catalog.base_price.value)")
                                                .font(.custom("Urbanist", size: 14))
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)))
                                                .strikethrough(true, color: (Color(UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00))))
                                                .lineLimit(1)
                                            
                                            Text("(\(Int(discountPercentage.rounded()))% off)")
                                                .font(
                                                    Font.custom("Urbanist", size: 12)
                                                        .weight(.bold)
                                                )
                                                .kerning(0.4)
                                                .foregroundColor(Color(red: 0, green: 0.76, blue: 0.35))
                                        }
                                    }
                                    Rectangle()
                                        .fill(Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)))
                                        .frame(width:164, height: 24)
                                        .cornerRadius(6)
                                        .overlay(
                                            HStack {
                                                Image("commissionIcon")
                                                    .font(.system(size: 12))
                                                    .frame(alignment: .leading)
                                                
                                                Text("Commission")
                                                    .font(.custom("Urbanist", size: 12))
                                                    .frame(height: 16)
                                                    .fontWeight(.bold)
                                                    .frame(alignment: .leading)
                                                
                                                Spacer()
                                                
                                                Text("\(catalog.commission_rate)%")
                                                    .font(.custom("Urbanist", size: 12))
                                                    .fontWeight(.bold)
                                            }
                                                .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                                        )
                                        .padding(.vertical)
                                    
                                    
                                }
                                .padding(.top,40)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, minHeight: 137, alignment: .leading)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 0.7)
                            )
                        }
                        .padding(.horizontal, 16)
                        
                    }
                }
                .padding(.vertical, 16)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .foregroundColor(.white)
                .overlay(
                    Button(action: {
                        isShowingBottomSheet = false
                    }, label: {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .frame(width: 343, height: 44, alignment: .center)
                                .foregroundColor(Color(UIColor(red: 0.98, green: 0.42, blue: 0.14, alpha: 1.00)))
                                .cornerRadius(14)
                            
                            Text("Add Products")
                                .font(Font.custom("Urbanist", size: 14).weight(.bold))
                                .kerning(0.2)
                                .foregroundColor(.white)
                        }
                    })
                )
        }
        .onDisappear {
            isShowingBottomSheet = false
        }
    }
}

