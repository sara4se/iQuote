//
//  ContentView.swift
//  iQuote
//
//  Created by Sara Alhumidi on 18/06/1444 AH.
//

import SwiftUI
import VisionKit


struct ContentView: View {
    @EnvironmentObject var coreDM: CoreDataManager
    @State private var showCameraScannerView = false
    @State private var isDeviceCapacity = false
    @State private var showDeviceNotCapacityAlert = false
    @State var cheak = false
    @State private var scanResults: String = ""
    @State private var searchText = ""
    @State var listAllQuote: [QuotesData] = []
    @State var listQuote: [String] = []
    var searchResults : [String] {
        if searchText.isEmpty {
            return listQuote
        } else {
            return listQuote.filter { $0.contains(searchText) }
        }
    }
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color(.white))]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
    }
    
    
    
    var body: some View {
        NavigationView(){
            VStack {
                VStack {
                    ZStack {
                        // strat
                        VStack{
                            VStack(alignment: .center){
                                ScrollView{
                                    //ScrollView(.vertical, showsIndicators: false){
                                    List{
                                        ForEach(coreDM.quotes, id: \.self) { Quote in
                                            GeometryReader { proxy in
                                                let scale = getScale(proxy: proxy)
                                                
                                                
                                                VStack{
                                                    //  List{
//                                                    ScrollView {
                                                        ZStack{
                                                            Image("card")
                                                                .resizable()
                                                                .scaledToFit()
                                                            // .frame(width: 380)
                                                                .frame(width: 400, height: 220)
                                                            //  .clipped()
                                                                .cornerRadius(8)
                                                                .shadow(radius: 3)
                                                          
                                                            Text(Quote.quotes_text ?? "").accessibilityLabel(Quote.quotes_text ?? "")
                                                            //                                                        Text("Be yourself; everyone else is already taken, Dont give up")
                                                                .padding(50)
                                                                .foregroundColor(.white)
                                                            
                                                            
                                                        }
//                                                    }
                                                    
                                                    
                                                }
                                                .frame(width: 400, height: 230)
                                                //                                                          .padding(.horizontal, 10)
                                                //                                                          .padding(.vertical, 10)
                                                //                                                          .padding(.top, -5)
                                                .scaleEffect(.init(width: scale, height: scale))//.background(.red)
                                                // .animation(.spring(), value: 3)
                                                //  .animation(.easeInOut)
                                                .animation(.easeOut(duration: 2))
                                                //                                                          .padding(.vertical)
                                                //end of geometry
                                                .swipeActions {
//                                                    Button(action: {
////                                                        ShareLink(item: Quote.quotes_text ?? "") {Label("Tap me to share", systemImage:  "square.and.arrow.up")
////                                                    }
//                                                        let url = URL(string:  Quote.quotes_text ?? "")
//                                                        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//
//                                                        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
//                                                    }) {
//                                                    Label("", systemImage: "square.and.arrow.up")
//                                                    }
//                                                    Button {
//                                                        print("Mark as favorite")
//                                                    } label: {
//                                                        Label("Favorite", systemImage: "star")
//                                                    }
//                                                    .tint(.yellow)
                                                    
                                                    Button {
                                                        print("Delete")
                                                        coreDM.deleteQuotes(quotesData:Quote)
                                                        
                                                        if ((Quote.quotes_text?.isEmpty) != nil)
                                                        {
                                                            cheak = true
                                                        }
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                    .tint(.red)
                                                    
                                                }
                                            }//Scrollview/foreach
                                            
                                        }
                                        .frame(width: 370, height: 230).listRowBackground(Color.clear)
                                        //scrollContentBackground(.hidden)
                                        .listRowSeparator(.hidden)
                                        
                                    }.listStyle(.plain)
                                    //                                    .listRowBackground(Color.clear)
                                        .scrollContentBackground(.hidden)
                                        .frame(width: 430, height: 710)
                                    }
                                //.frame(width: .infinity, height: .infinity)//end of geometry
                                
                                
                            }
                            //.frame(width: 430, height: 250)
                            
                        }
                    } .background {
                        Image("2")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        
                        VisualEffectView(effect: UIBlurEffect(style: .dark))
                            .edgesIgnoringSafeArea(.all)
                        
                    }
                }
                .sheet(isPresented: $showCameraScannerView) {
                    CameraScanText(startScanning: $showCameraScannerView, scanResult: $scanResults, listQuote: $listQuote)
                   
                }
                .alert("Scanner Unavailable", isPresented: $showDeviceNotCapacityAlert, actions: {}).accessibilityLabel("Scanner Unavailable")
                .onAppear {
                    isDeviceCapacity = (DataScannerViewController.isSupported &&
                                        DataScannerViewController.isAvailable)
                    populateQuotes()
                }
            }.toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        if isDeviceCapacity {
                            self.showCameraScannerView = true
                        } else {
                            self.showDeviceNotCapacityAlert = true
                        }
                    } label: {
                        Image(systemName: "plus").accessibilityLabel("plus").accessibilityHint("this Button will active the camera scanner ").font(.system(size: 24))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        
                    }
                    
                    .navigationBarTitle(Text("Quotes").foregroundColor(.white), displayMode: .large).foregroundColor(.white).navigationBarHidden(false)
                    
                    
                    
                }
            }.searchable(text: $searchText)
            
            
            
            //  .textFieldStyle(.roundedBorder)
            
            
            
            
        }
//        .onAppear{
//            pupdateAllQuotes()
//            populateQuotes() }
    }
    func pupdateAllQuotes() {
        coreDM.quotes = coreDM.updateQuotes()
    }
    func populateQuotes() {
        coreDM.quotes = coreDM.getAllQuotes()
    }
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 80
        
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1
        let deltaXAnimationThreshold: CGFloat = 80
        
        let diffFromCenter = abs(midPoint - viewFrame.origin.y / 4)
        
        
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        
        return scale
    }
    
}//function

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CoreDataManager())
    }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}




//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
//        if let nc = uiViewController.navigationController {
//            self.configure(nc)
//        }
//    }
//
//}


