//
//  ContentView.swift
//  SecondSave
//
//  Created by IDEA Lab on 2021/4/12.
//

// ðï¼åå°ä¿æè®¡æ¶
// ðï¼åç§æ¢ç®
// ðï¼ä½¿æåæ¶ä¹è½ mark
// ðï¼å¢å  stop/reset æé®
// âï¼è®¡æ¶ãæ»å¨åè¡¨çå¼æ­¥å¤ç
// âï¼ä½¿æ°å¢çè®°å½åºç°å¨æé¡¶ç«¯ / èªå¨æ´æ°è³åºé¨
// ðï¼èèå¢å  copy æé®
// ðï¼è°æ´å¤å¶éç¥ç animation
// âï¼æåæ¶ç¦ç¨ mark
// âï¼Mark æé®è§¦åæ¡
// âï¼åæ¢ Color Scheme æ¨¡å¼å­¦ä¹ 

import SwiftUI

class StopWatchManager: ObservableObject {
    @Published var timeCount: Double = 0.0
    var timer = Timer()
    
    var laps = [String]()
    
    var str: String = ""
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeCount += 0.1
            // ä½¿æ»å¨åè¡¨çåæ¶ä¹è½è®¡æ°
            RunLoop.main.add(self.timer, forMode: .common)
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
        GeometryReader { geo in
            ZStack {
                Color(UIColor(named: "AccentColor")!)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
                ZStack {
                    VStack(spacing: 0) {
                        ZStack {
                            Button(action: {}, label: {})
                                .frame(width: geo.size.width - 44, height: 100)
                                // button çå®½é«
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
                                ScrollViewReader { scrollview in
                                    
                                    ForEach(0 ..< self.stopWatchManager.laps.count, id: \.self) { index in

                                        LazyVStack {
                                            HStack {
                                                Group {
                                                    Text("\(index + 1)")
                                                        .frame(width: 80, height: 40, alignment: .center).font(Font.custom("PresicavXl-Regular", size: 24))
                                            
                                                    Spacer()
                                            
                                                    Text("\(self.stopWatchManager.laps[index])")
                                                        .font(Font.custom("PresicavXl-Regular", size: 24))
                                            
                                                    Text("s")
                                                        .frame(width: 40, height: 40, alignment: .center)
                                                        .padding(.trailing, 10.0)
                                                        .font(Font.custom("PresicavXl-Regular", size: 24))
                                                }
                                                .foregroundColor(.white)
                                            }
                                            Rectangle()
                                                .frame(width: geo.size.width - 78, height: 1)
                                                .foregroundColor(Color.white.opacity(0.1))
                                        }
                                        
                                        // ç¹å» Mark æ¶èªå¨æ´æ°è³åºé¨
                                        .onAppear {
                                            scrollview.scrollTo(self.stopWatchManager.laps.endIndex - 1)
                                                
                                         
                                                
                                            // print("hihi\(self.stopWatchManager.laps.endIndex)")
                                        }
   
                                        .padding(.top, 8.0)
                                        .padding(.bottom, 2.0)
                                    }
                                }
                            }

                            .onTapGesture {
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
                        }
                        .frame(width: geo.size.width - 44, alignment: .center)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 22.0)
                        .padding(.bottom, 16.0)
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
                                    .frame(width: 62, height: 62)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            Spacer()
                                .frame(width: 20)
                        
                            Button(action: {
                                // if self.isPlaying == true {
                                print(self.stopWatchManager.timeCount)
                                stopWatchManager.addLap(time: stopWatchManager.timeCount)
                                print(self.stopWatchManager.laps)
                                // }
                                
                            }, label: {
                                Text("mark")
                                    .font(Font.custom("PresicavRg-Bold", size: 28)).foregroundColor(Color.white)
                                    .frame(minWidth: 0, maxWidth: geo.size.width, minHeight: 62)
                                    .background(Color.white.opacity(0.1))

                                    .cornerRadius(8)
                                
                            })
                        }
                        .frame(width: geo.size.width - 44)
                        .padding(.bottom, 20)
                    }.padding(.top, 40)
                }
            
                BannerModifier()
                    // .offset(y: self.isCopied ? -UIScreen.main.bounds.height / 2.41 : -UIScreen.main.bounds.height / 1.2)
                    .offset(y: self.isCopied ? 0 : -UIScreen.main.bounds.height / 1.2)
                    .animation(.interpolatingSpring(mass: 1, stiffness: 60.0, damping: 12, initialVelocity: 0))
            }
        }
    }
   
    func timestring(time: Double) -> String {
        return String(format: "%.1f", time)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
