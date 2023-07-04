//
//  ItemView.swift
//  Spotlight
//
//  Created by Jai Deep on 30/06/23.
//

import SwiftUI

struct ItemView: View {
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 163))]){
                ForEach(1...6, id: \.self){ catalog in
                    ZStack{
                        VStack(alignment: .leading){
                            Image("batman")
                                .resizable()
                                .frame(width: 164.5, height: 215.52)
                                .cornerRadius(12)
                                .offset(x: 0)
                            Text("Puma")
                                .font(
                                    Font.custom("Urbanist", size: 12)
                                        .weight(.bold)
                                )
                                .kerning(0.4)
                                .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                            Text("Forest bomber jacket with Hoodie")
                                .font(
                                    Font.custom("Urbanist", size: 12)
                                        .weight(.medium)
                                )
                                .kerning(0.4)
                                .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                .frame(width: 155, height: 32, alignment: .topLeading)
                            Text("₹1,529")
                              .font(
                                Font.custom("Urbanist", size: 14)
                                  .weight(.bold)
                              )
                              .kerning(0.2)
                              .foregroundColor(Color(red: 0.07, green: 0.08, blue: 0.11))
                            Rectangle()
                                .frame(width: 163)
                                .foregroundColor(Color(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)))
                                .frame(height: 24)
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
                                        
                                        Text("(15%)")
                                            .font(.custom("Urbanist", size: 12))
                                            .fontWeight(.bold)
                                    }
                                        .foregroundColor(Color(UIColor(red: 0.07, green: 0.08, blue: 0.11, alpha: 1.00)))
                                )
                                .padding(.vertical)
                        }
                        Image("AddProductsIcon")
                            .frame(width: 30,height: 30)
                            .foregroundColor(Color(UIColor(red: 0.98, green: 0.42, blue: 0.14, alpha: 1.00)))
                            .cornerRadius(5)
                            .offset(x: 55,y: 33)
                            
                        .padding()
                    }
                }
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
