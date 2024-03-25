 //
 //  MenuView.swift
 //  FiTagotchi Watch App
 //
 //  Created by Alessandro on 19/02/24.
 //

 import SwiftUI

 struct MenuItemView: View {
     var destination: AnyView
     var imageName: String
     var title: String

     var body: some View {
         NavigationLink(destination: destination) {
             HStack {
                 Image(systemName: imageName)
                 Text(title)
             }
         }
     }
 }

 struct MenuView: View {
     @EnvironmentObject var fiTagotchiData: FiTagotchiData
     @ObservedObject var health: HealthManager
     var statistic: StatisticCircleView?


     var body: some View {
         List {
             MenuItemView(destination: AnyView(MissionView(health: health)),
                          imageName: "list.bullet.clipboard.fill",
                          title: "Missions")
             
             MenuItemView(destination: AnyView(BagView(inventory: fiTagotchiData.inventory, statistic: statistic ?? StatisticCircleView(iconName: "heart.fill", fitagotchi: fiTagotchiData))),
                          imageName: "backpack.fill",
                          title: "Bag")

             MenuItemView(destination: AnyView(FoodView(inventory: fiTagotchiData.inventory)),
                          imageName: "takeoutbag.and.cup.and.straw.fill",
                          title: "Food")
             
             MenuItemView(destination: AnyView(RenameView()),
                          imageName: "person.text.rectangle.fill",
                          title: "Rename")
             
             MenuItemView(destination: AnyView(TutorialView()),
                          imageName: "graduationcap.fill",
                          title: "Tutorial")
             
             MenuItemView(destination: AnyView(SettingsView()),
                          imageName: "gearshape.fill",
                          title: "Settings")
         }
         
         // Vecchio stile del menu
 //        ScrollView {
 //            VStack(alignment: .leading) {
 //                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
 //                }
 //                .padding()
 //            }
 //        }
     }
 }

 
//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        let fiTagotchiData = FiTagotchiData()
//        return MenuView(fiTagotchiData: fiTagotchiData, health: HealthManager)
//    }
//}
 
