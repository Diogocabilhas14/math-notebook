import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct MainNotebookView: View {
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var mathResult: String = ""
    @State private var recognizedText: String = ""
    @State private var isProcessing: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Folha de caderno pautada
            GridBackground()
                .edgesIgnoringSafeArea(.all)

            // Canvas de desenho PencilKit
            CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                .edgesIgnoringSafeArea(.all)

            // Painel de controle e resultado
            VStack(spacing: 10) {
                if !recognizedText.isEmpty {
                    Text("Expressão: \(recognizedText)")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(.secondary)
                }

                if !mathResult.isEmpty {
                    Text(mathResult)
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                }

                HStack(spacing: 16) {
                    Button(action: clearCanvas) {
                        Label("Limpar", systemImage: "trash")
                            .font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    Button(action: processMath) {
                        HStack {
                            if isProcessing {
                                ProgressView()
                                    .padding(.trailing, 4)
                            } else {
                                Image(systemName: "sparkles")
                            }
                            Text("Calcular")
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
            .padding(.bottom, 28)
        }
    }

    private func clearCanvas() {
        canvasView.drawing = PKDrawing()
        recognizedText = ""
        mathResult = ""
    }

    private func processMath() {
        guard !canvasView.drawing.bounds.isEmpty else { return }
        isProcessing = true
        let drawing = canvasView.drawing
        let image = drawing.image(from: drawing.bounds, scale: 2.0)

        MathOCRService.recognizeFormula(from: image) { expression in
            DispatchQueue.main.async {
                self.recognizedText = expression
                self.mathResult = MathSolver.evaluate(expression: expression)
                self.isProcessing = false
            }
        }
    }
}

struct GridBackground: View {
    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 30.0
            var path = Path()
            
            for y in stride(from: 0, to: size.height, by: step) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1.0)
        }
        .background(Color(UIColor.systemBackground))
    }
}
