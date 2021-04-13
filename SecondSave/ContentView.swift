//
//  ContentView.swift
//  SecondSave
//
//  Created by IDEA Lab on 2021/4/12.
//

// 📓：增加 stop/reset 按钮
// 📓：计时、滑动列表的异步处理
// 📓：使新增的记录出现在最顶端
// 📓：考虑增加 copy 按钮


import SwiftUI

class StopWatchManager: ObservableObject {
    @Published var timeCount: Double = 0.0
    var timer = Timer()
    
    var laps = [String]()
    
    var str: String = ""
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeCount += 0.1
        }
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func stop() {
        timer.invalidate()
        timeCount = 0.0
    }
    
    func addLap(time: Double) {
        laps.append(String(format: "%.1f", time))
    }
}

struct ContentView: View {
    // @State var timeCount: Double = 0.0
    @ObservedObject var stopWatchManager = StopWatchManager()
    
    @State var isPlaying: Bool = false
    @State var isCopied: Bool = false
    
//    var timer: Timer {
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            self.timeCount += 0.1
//        }
//    }

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
            ZStack {
                VStack {
                    ZStack {
                        Button(action: {}, label: {})
                            .frame(width: 330, height: 100) // button 的宽高
                            .background(Color.white)
                            .cornerRadius(8)
                            
                        HStack {
                            Text(timestring(time: self.stopWatchManager.timeCount))
                                .font(Font.custom("PresicavRg-Bold", size: 48))
                                .foregroundColor(Color.black)
                            
                            
                            Text("s")
                                .font(Font.custom("PresicavRg-Bold", size: 48))
                                .foregroundColor(Color.black)
                        }
                    }
                    
                    ZStack {
                        ScrollView {
                            ForEach(0 ..< self.stopWatchManager.laps.count, id: \.self) { index in
                                VStack {
                                    HStack {
                                        Group {
                                            Text("\(index + 1)")
                                                .frame(width: 80, height: 40, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/).font(Font.custom("PresicavXl-Regular", size: 24))
                                            
                                            Spacer()
                                            
                                            Text("\(self.stopWatchManager.laps[index])")
                                                .font(Font.custom("PresicavXl-Regular", size: 24))
                                            
                                            Text("s")
                                                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                                .padding(.trailing, 10.0)
                                                .font(Font.custom("PresicavXl-Regular", size: 24))
                                        }
                                        .foregroundColor(.white)
                                    }
                                    Rectangle()
                                        .frame(width: 296, height: 1)
                                        .foregroundColor(Color.white.opacity(0.1))
                                }
                                .padding(.top, 8.0)
                            }
                        }.onTapGesture {
                            print("List onTap")
                            if self.isPlaying == false {
                                self.stopWatchManager.str = ""
                                for index in 1 ... self.stopWatchManager.laps.count {
                                    self.stopWatchManager.str += "\(index): \(self.stopWatchManager.laps[index - 1])s\n"
                                }
                                
                                self.isCopied.toggle()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.isCopied.toggle()
                                }
                                
                                UIPasteboard.general.string = self.stopWatchManager.str
                            }
                        }

                        // .colorMultiply(Color.white.opacity(0.1))
                    }
                    .frame(width: 330, height: 420, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 22.0)
                    .padding(.bottom, 20.0)
                    .padding(.top, 16.0)
                    HStack {
                        Button(action: {
                            if self.isPlaying == true {
                                self.stopWatchManager.pause()
                                
                            } else {
                                self.stopWatchManager.start()
                            }
                           
                            self.isPlaying.toggle()
                        }) {
                            Image(systemName: self.isPlaying == true ? "pause.fill" : "play.fill")
                                .resizable()
                                .frame(width: 22, height: 22, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                        }
                        .frame(width: 62, height: 62)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        Button(action: {
                            print(self.stopWatchManager.timeCount)
                            stopWatchManager.addLap(time: stopWatchManager.timeCount)
                            print(self.stopWatchManager.laps)
                            
                        }, label: {
                            Text("mark")
                                .font(Font.custom("PresicavRg-Bold", size: 28)).foregroundColor(Color.white)
                                
                        })
                            .frame(width: 249, height: 62)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 20)
                }.padding(.top, 70)
            }
            
            BannerModifier()
                .offset(y: self.isCopied ? -UIScreen.main.bounds.height / 2.41 : -UIScreen.main.bounds.height / 1.2 )
                .animation(.interpolatingSpring(mass: 1, stiffness: 60.0, damping: 12, initialVelocity: 0))
        }
    }

    func timestring(time: Double) -> String {
        return String(format: "%.1f", time)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
