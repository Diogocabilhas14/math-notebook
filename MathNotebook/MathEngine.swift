import UIKit
import Vision
import JavaScriptCore

class MathOCRService {
    static func recognizeFormula(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion("")
                return
            }

            let fullText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            completion(sanitizeMathText(fullText))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    private static func sanitizeMathText(_ raw: String) -> String {
        return raw
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "X", with: "*")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

class MathSolver {
    private static let context = JSContext()

    static func evaluate(expression: String) -> String {
        guard !expression.isEmpty, let context = context else { return "Vazio" }

        let allowed = CharacterSet(charactersIn: "0123456789+-*/().^ ")
        if expression.unicodeScalars.contains(where: { !allowed.contains($0) }) {
            return "Inválido: \(expression)"
        }

        let formatted = expression.replacingOccurrences(
            of: "(\\d+)\\^(\\d+)",
            with: "Math.pow($1,$2)",
            options: .regularExpression
        )

        if let val = context.evaluateScript(formatted), val.isNumber {
            return "= \(val.toString() ?? "")"
        }
        return "Erro de cálculo"
    }
}
