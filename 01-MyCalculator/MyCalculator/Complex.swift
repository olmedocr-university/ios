import Foundation

struct Complex {
    
    // MARK: Properties
    private var realPart: Double
    private var imaginaryPart: Double
    
    // MARK: Computed properties
    var polarForm: (modulus: Double, argument: Double) {
        get {
            let modulus = sqrt(pow(realPart, 2) + pow(imaginaryPart, 2))
            let argument = atan2(imaginaryPart, realPart)
            return (modulus, argument)
        }
        set {
            self.realPart = newValue.modulus * cos(newValue.argument)
            self.imaginaryPart = newValue.modulus * sin(newValue.argument)
        }
    }
    
    var cartesianForm: (x: Double, y: Double) {
        get {
            return (self.realPart, self.imaginaryPart)
        }
        set {
            self.realPart = newValue.x
            self.imaginaryPart = newValue.y
        }
    }
    
    // MARK: - Constructors
    // Cartesian constructor
    init(realPart: Double, imaginaryPart: Double) {
        self.realPart = realPart
        self.imaginaryPart = imaginaryPart
    }
    
    // Polar constructor
    init(modulus: Double, argument: Double) {
        self.realPart = modulus * cos(argument)
        self.imaginaryPart = modulus * sin(argument)
    }
    
    // MARK: - Function operators
    static func + (a: Complex, b: Complex) -> Complex {
        return Complex(realPart: a.realPart + b.realPart, imaginaryPart: a.imaginaryPart + b.imaginaryPart)
    }

    static func - (a: Complex, b: Complex) -> Complex {
        return Complex(realPart: a.realPart - b.realPart, imaginaryPart: a.imaginaryPart - b.imaginaryPart)
    }

    static func * (a: Complex, b: Complex) -> Complex {
        let aInPolar = a.polarForm
        let bInPolar = b.polarForm
        return Complex(modulus: aInPolar.modulus * bInPolar.modulus, argument: aInPolar.argument + bInPolar.argument)
    }

    static func / (a: Complex, b: Complex) -> Complex {
        let aInPolar = a.polarForm
        let bInPolar = b.polarForm
        return Complex(modulus: aInPolar.modulus / bInPolar.modulus, argument: aInPolar.argument - bInPolar.argument)
    }

}
