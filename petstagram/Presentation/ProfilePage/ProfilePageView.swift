//
//  ProfilePageView.swift
//  petstagram
//
//  Created by Parama Artha on 08/05/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePageView : View {
    @State private var selectedProfileTab = 0
    @StateObject private var viewModel: ProfilePageViewModel
    @State private var tabHeights: [CGFloat] = [0, 0, 0]
    
    init() {
        let di = DIContainer.shared
        _viewModel = StateObject(wrappedValue: di.generateProfilePageViewModel())
    }
    
    var body : some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(alignment: .center) {
                        WebImage(url: URL(string: viewModel.imgUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 108, height: 108)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 1) {
                            Text(viewModel.fullName)
                                .font(Theme.Fonts.bodyLargeBold)
                            Text(viewModel.username)
                                .font(Theme.Fonts.bodyRegular)
                                .foregroundColor(Theme.Colors.dark1.opacity(0.6))
                            Text(viewModel.dateOfBirth)
                                .font(Theme.Fonts.bodyRegular)
                                .foregroundColor(Theme.Colors.dark1.opacity(0.6))
                                .padding(.bottom, 2)
                            NavigationLink(destination: EditProfilePageView()){
                                HStack {
                                    Image("Edit")
                                        .renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.white)
                                    Text("Edit Profile")
                                        .font(Theme.Fonts.bodySemiBold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Theme.Colors.primary1)
                                .cornerRadius(16)
                            }
                            .accessibilityIdentifier("EditProfileButton")
                        }
                        .padding(.leading)
                    }
                    
                    if(!viewModel.bio.isEmpty){
                        Text(viewModel.bio)
                            .font(Theme.Fonts.bodyRegular)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.Colors.secondary1)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    ButtonStyleTabBar(selectedTab: $selectedProfileTab)
                    
                    TabView(selection: $selectedProfileTab) {
                        InfoTab(viewModel: viewModel)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        tabHeights[0] = geo.size.height
                                    }
                                }
                            )
                            .tag(0)
                        
                        PostTab(viewModel: viewModel)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        tabHeights[1] = geo.size.height
                                    }
                                }
                            )
                            .tag(1)
                    }
                    .frame(height: tabHeights[selectedProfileTab] + 64)
                    
                    Button(action: viewModel.signOut) {
                        Text("Sign Out")
                            .font(Theme.Fonts.bodyLargeSemiBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.primary1)
                            .cornerRadius(16)
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.getUserData()
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $viewModel.showEditInfoSheet) {
            EditInfoSheetView(isPresented: $viewModel.showEditInfoSheet, viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showEditLifeEventSheet) {
            EditLifeEventSheetView(isPresented: $viewModel.showEditLifeEventSheet, viewModel: viewModel)
        }
    }
}

struct EditInfoSheetView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ProfilePageViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CustomTextField(placeholder: "Name", text: $viewModel.name, required: true)
                    CustomTextField(placeholder: "Born", text: $viewModel.born, required: true)
                    CustomTextField(placeholder: "Gender", text: $viewModel.gender, required: true)
                    CustomTextField(placeholder: "Breed", text: $viewModel.breed, required: true)
                    CustomTextField(placeholder: "Favorite Toy", text: $viewModel.favoriteToy)
                    CustomTextField(placeholder: "Habits", text: $viewModel.habits, isTextArea: true)
                    CustomTextField(placeholder: "Characteristics", text: $viewModel.characteristics, isTextArea: true)
                    CustomTextField(placeholder: "Favorite Food", text: $viewModel.favoriteFood)
                }
                .padding()
            }
            .navigationTitle("Edit Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveInfo()
                        isPresented = false
                    }
                    .font(Theme.Fonts.bodySemiBold)
                    .foregroundStyle(Theme.Colors.primary1)
                }
            }
        }
    }
}

struct EditLifeEventSheetView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ProfilePageViewModel
    @State private var lifeEvents: [[String: String]]
    
    init(isPresented: Binding<Bool>, viewModel: ProfilePageViewModel) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self._lifeEvents = State(initialValue: viewModel.listLifeEvents)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(lifeEvents.enumerated()), id: \.offset) { index, event in
                        LifeEventFormElement(event: event, index: index, lifeEvents: $lifeEvents)
                    }
                    
                    Button(action: {
                        lifeEvents.append(["": ""])
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Event")
                        }
                        .foregroundStyle(Theme.Colors.primary1)
                        .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Edit Life Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.listLifeEvents = lifeEvents
                        viewModel.saveInfo()
                        isPresented = false
                    }
                    .font(Theme.Fonts.bodySemiBold)
                    .foregroundStyle(Theme.Colors.primary1)
                }
            }
        }
    }
}

struct InfoTab: View {
    @ObservedObject var viewModel: ProfilePageViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Information")
                        .font(Theme.Fonts.h4)
                        .foregroundStyle(Theme.Colors.dark1)
                        .padding(.bottom, 4)
                    Spacer()
                    Button(action: {
                        viewModel.showEditInfoSheet = true
                    }) {
                        Image("Edit")
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Theme.Colors.primary1)
                    }
                }
                InfoContent(label: "Name:", value: viewModel.name)
                InfoContent(label: "Born:", value: viewModel.born)
                InfoContent(label: "Gender:", value: viewModel.gender)
                InfoContent(label: "Breed:", value: viewModel.breed)
                InfoContent(label: "Favorite Toy:", value: viewModel.favoriteToy)
                InfoContent(label: "Habits:", value: viewModel.habits)
                InfoContent(label: "Characteristics:", value: viewModel.characteristics)
                InfoContent(label: "Favorite Food:", value: viewModel.favoriteFood)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.Colors.grey1, lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Life Events")
                        .font(Theme.Fonts.h4)
                        .foregroundStyle(Theme.Colors.dark1)
                        .padding(.bottom, 4)
                    Spacer()
                    Button(action: {
                        viewModel.showEditLifeEventSheet = true
                    }) {
                        Image("Edit")
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Theme.Colors.primary1)
                    }
                }
                ForEach(viewModel.listLifeEvents, id: \.self) { lifeEvent in
                    InfoContent(label: lifeEvent.keys.first ?? "", value: lifeEvent.values.first ?? "", isLifeEvent: true)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.Colors.grey1, lineWidth: 1)
            )
        }
    }
}

struct PostTab: View {
    @ObservedObject var viewModel: ProfilePageViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 1) {
            ForEach(viewModel.posts, id: \.self) { post in
                WebImage(url: URL(string: post.imgUrl))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: ((UIScreen.main.bounds.width / 3)-12), height: ((UIScreen.main.bounds.width / 3)-12))
                    .clipped()
            }
        }
    }
}

struct InfoContent : View {
    let label: String
    let value: String
    var isLifeEvent: Bool = false
    var body : some View {
        HStack{
            Text(label)
                .font(Theme.Fonts.bodyLargeRegular)
                .frame(width: isLifeEvent ? 70 : 150, alignment: .leading)
            Text(value)
                .font(Theme.Fonts.bodyLargeSemiBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct LifeEventFormElement: View {
    var event: [String: String]
    var index: Int
    @Binding var lifeEvents: [[String:String]]
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            CustomTextField(
                placeholder: "Year",
                text: Binding(
                    get: { event.keys.first ?? "" },
                    set: { newValue in
                        lifeEvents[index] = [newValue: event.values.first ?? ""]
                    }
                ),
                required: true
            )
            .frame(width: 120)
            CustomTextField(
                placeholder: "Events",
                text: Binding(
                    get: { event.values.first ?? "" },
                    set: { newValue in
                        lifeEvents[index] = [event.keys.first ?? "": newValue]
                    }
                ),
                required: true,
                isTextArea: true
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfilePageView()
}


