import SwiftUI

// MARK: - Model
struct Flag {
    let symbol: String
}

// MARK: -  ViewModel
class FlagListViewModel: ObservableObject {
    @Published var flags: [Flag] = [
        Flag(symbol: "🇺🇸"),
        Flag(symbol: "🇬🇧"),
        Flag(symbol: "🇫🇷"),
        Flag(symbol: "🇩🇪"),
        Flag(symbol: "🇮🇹"),
        Flag(symbol: "🇪🇸"),
        Flag(symbol: "🇷🇺"),
        Flag(symbol: "🇨🇳"),
        Flag(symbol: "🇯🇵"),
        Flag(symbol: "🇰🇷")
    ]
}

// MARK: - View
struct FlagListView: View {
    @ObservedObject var viewModel: FlagListViewModel
    @State private var scrollTarget: Int? = nil
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        ForEach(viewModel.flags.indices, id: \.self) { index in
                            Text(viewModel.flags[index].symbol)
                                .font(.system(size: 50))
                                .padding()
                                .frame(width: 100, height: 100)
                                .id(index)
                        }
                    }
                    .onChange(of: scrollTarget) { target in
                        if let target = target {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                proxy.scrollTo(target, anchor: .bottom)
                            }
                            scrollTarget = nil
                        }
                    }
                }
            }
            .frame(width: 100, height: 100)
            .border(.black, width: 3)
            
            Spacer()
            
            Button(action: {
                if let lastIndex = viewModel.flags.indices.last {
                    scrollTarget = lastIndex
                }
            }) {
                Text("Hit me!")
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.bold)
            }
            .padding(10)
        }
        .padding(10)
    }
}

struct ContentView: View {
    @StateObject var viewModel = FlagListViewModel()
    
    var body: some View {
        FlagListView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
