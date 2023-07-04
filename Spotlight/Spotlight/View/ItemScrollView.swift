//
//  ItemScrollView.swift
//  Spotlight
//
//  Created by Jai Deep on 24/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemScrollView: View {
    @ObservedObject var spotlightViewModel: SpotlightViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Products (\(spotlightViewModel.catalogs.count))")
                    .font(
                        Font.custom("Urbanist", size: 16)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                    .tracking(0.2)
                    .padding(.top)
                    .padding(.leading, 30)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 20)], spacing: 16) {
                    ForEach(spotlightViewModel.catalogs, id: \.id) { catalog in
                        CatalogView(catalog: catalog)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
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
                selectItem(catalog.id)
            }) {
                Image(spotlightViewModel.selectedItems.contains(catalog.id) ? "SelectedIcon" : "AddProductsIcon")
            }
            .padding(.bottom, 130)
            .padding(.trailing,20)
            .padding(.leading, 8)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
    
    private func selectItem(_ id: String) {
        if spotlightViewModel.selectedItems.contains(id) {
            spotlightViewModel.selectedItems.remove(id)
        } else {
            spotlightViewModel.selectedItems.insert(id)
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




//let itemModel = []
//struct ItemScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ItemScrollView(isRectangleTapped: .constant(false), spotlightViewModel: itemModel)
//    }
//}
