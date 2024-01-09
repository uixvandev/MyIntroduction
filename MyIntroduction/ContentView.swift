import SwiftUI

struct Question {
    let statement : String
    let isTrue : Bool
    
}

struct ContentView: View {
    let questions: [Question] = [
        Question(statement: "Saya adalah seorang Mahasiswi", isTrue: false),
        Question(statement: "Saya bisa menggunakan bahasa Kotlin", isTrue: true),
        Question(statement: "Saya pernah ke Belanda", isTrue: false)
        
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var showAnswer = false
    @State private var buttonsDisabled = false
    @State private var lastAnswer:Bool?
    
    var body: some View{
        ScrollView {
            VStack(spacing: 20){
                ZStack {
                    Circle()
                        .frame(height: 80)
                        .shadow(radius: 10)
                    
                    Image(systemName: "doc.questionmark.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                }
                Text(questions[currentQuestionIndex].statement)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                
                Button("Fakta") {
                    checkAnswer(true)
                }
                .buttonStyle(AnswerButtonStyle(isDisabled: buttonsDisabled))
                .disabled(buttonsDisabled)
                
                Button("Fiksi") {
                    checkAnswer(false)
                }
                .buttonStyle(AnswerButtonStyle(isDisabled: buttonsDisabled))
                .disabled(buttonsDisabled)
                
                if showAnswer, let lastAnswer = lastAnswer {
                    Text(lastAnswer ? "Benar!" : "Salah!")
                        .font(.headline)
                        .foregroundStyle(lastAnswer ? .green : .red)
                }
                MarkdownText()
            }
            .padding()
        }
    }
    
    func checkAnswer(_ userAnswer:Bool){
        buttonsDisabled = true
        let correctAnswer = questions[currentQuestionIndex].isTrue
        
        lastAnswer = (userAnswer == correctAnswer)
        
        if lastAnswer ?? false {
            print("Jawaban anda benar!")
        } else {
            print("Jawaban anda salah")
        }
        showAnswer = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
            } else {
                currentQuestionIndex = 0
            }
            
            showAnswer = false
            buttonsDisabled = false
            lastAnswer = nil
        }
    }
}

struct AnswerButtonStyle: ButtonStyle {
    var isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding()
            .background(isDisabled ? Color.gray : Color.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct MarkdownText :View {
    var body: some View {
        VStack{
            Text("""
            **Perkenalan**
            Halo! Nama saya **Irfan Wahendra**, biasa dipanggil *Irfan*.
                        
            Saya adalah seorang __UI/UX Designer__ yang bekerja di perusahaan [Appskep](https://landing.appskep.id/) dan juga mahasiswa semester 5 di [Universitas Andalas](https://unand.ac.id/)
                        
            Saat ini domisili saya di ~~Tokyo~~ **Padang**.
                        
            Quote favorite saya:
            ***Lokasi lahir boleh di mana saja, tapi lokasi mimpi harus di langit***
                        
            Salam kenal semuanya!
            """)
            .padding()
            .border(Color.gray, width: 1)
        }
        .padding(.top, 20)
    }
}

#Preview {
    ContentView()
}

