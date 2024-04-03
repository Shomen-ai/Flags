import SwiftUI

// MARK: - Model
struct Flag {
    let symbol: String
}

// MARK: - ViewModel
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
    @State private var contentOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(viewModel.flags.indices, id: \.self) { index in
                            Text(viewModel.flags[index].symbol)
                                .font(.system(size: 50))
                                .padding()
                                .frame(width: 100, height: 100)
                                .id(index)
                        }
                    }
                    .background(.red)
                    .offset(y: min(contentOffset, 0))
                }
                
                .frame(width: 100, height: 100)
                .border(.black, width: 3)
                .onChange(of: scrollTarget) { target in
                    guard let target = target else { return }
                    let indexHeight = CGFloat(target) * 100
                    withAnimation(Animation.easeInOut(duration: 1.5)) {
                        contentOffset = (-indexHeight + (geometry.size.height)).rounded(.awayFromZero)
                    }
                }
            }
            .frame(width: 100, height: 100)
            .background(.green)
            
            Spacer()
            
            Button(action: {
                scrollTarget = Int.random(in: 0..<viewModel.flags.count)
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
