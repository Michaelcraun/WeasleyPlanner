//
//  Fraction.swift
//  prog2.1
//
//  Created by Lech Szymanski on 2/06/15.
//  Tweaked / checked for Swift 3.1 by Dave Eyers in July 2017.
//  Copyright (c) 2015 Lech Szymanski. All rights reserved.
//

import Foundation
/**
 Represents a number as a fraction of two integers
 */
class Fraction {
    // STORED PROPERTIES
    private var num: Int;   // Numerator
    private var den: Int;   // Denominator
    
    // COMPUTED PROPERTIES
    
    /**
     Converts fraction to a Float value
     
     - returns: Float Decimal value of the fraction
     */
    var decimal: Float {
        get {
            // num and den are of type Int, therefore,
            // they need to be explicitly converted to Floats
            return Float(self.num)/Float(self.den);
        }
    }
    
    /**
     Converts object to a string description
     
     - returns: String String representation of a fraction
     */
    var description: String {
        if self.num == self.den {
            return "\(self.den)"
        }
        return "\(self.num)/\(self.den)"
    }
    
    // INITIALISERS
    
    /**
     Default initialiser
     
     Numerator gets set to 0 and denominator gets set to 1
     */
    init() {
        // Setting numerator to 0 and
        // denominator to 1 is equivalent
        // to setting the fraction to zero
        self.num = 0
        self.den = 1
    }
    
    /**
     Designated initialiser
     
     Numerator and denominator values are passed in the arguments of the initialiser.
     
     - parameter num: Fraction's numerator
     - parameter den: Fraction's denominator
     */
    init(num : Int, den : Int) {
        
        // Check the denominator...
        assert(den != 0, "Denominator cannot be zero")
        
        self.num = num
        self.den = den
        
        self.reduce()
    }
    
    /**
     Convenience initialiser
     
     Numerator is set to some value, denominator
     is set to 1.
     
     - parameter num: Fraction's numerator
     */
    convenience init(num : Int) {
        self.init(num: num, den: 1);
    }
    
    // METHODS
    
    /**
     Adds a fraction to self.
     
     - parameter f: Fraction to add to self
     
     - returns: Fraction The result of adding f to self.
     */
    func add(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.den + self.den*f.num,
                        den: self.den*f.den)
    }
    
    /**
     Subtracts fraction from self.
     
     - parameter f: Fraction to subtract from self
     
     - returns: Fraction The result of subtracting f from self.
     */
    func subtract(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.den - self.den*f.num,
                        den: self.den*f.den)
    }
    
    /**
     Multiplies self by a fraction.
     
     - parameter f: Fraction to multiply self by
     
     - returns: Fraction The result of multiplying self by f.
     */
    func multiply(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.num, den: self.den*f.den)
    }
    
    /**
     Divides self by a fraction.
     
     - parameter f: Fraction to divide self by
     
     - returns: Fraction The result of dividing self by f.
     */
    func divide(_ f: Fraction) -> Fraction {
        return Fraction(num: self.num*f.den, den: self.den*f.num)
    }
    
    /**
     Add a fraction to fraction.
     
     - parameter f1: Fraction to add to
     - parameter f2: Fraction to be added
     
     - returns: The result of f1 + f2.
     */
    static func add(_ f1: Fraction, to f2: Fraction) -> Fraction {
        return Fraction(num: f1.num*f2.den + f1.den*f2.num,
                        den: f1.den*f2.den)
    }
    
    /**
     Subtract a fraction from fraction.
     
     - parameter f1: Fraction to subtract
     - parameter f2: Fraction to subtract from
     
     - returns: The result of f2 - f1.
     */
    static func subtract(_ f1: Fraction, from f2: Fraction) -> Fraction {
        return f2.subtract(f1);
    }
    
    /**
     Multiply a fraction by fraction.
     
     - parameter f1: Fraction to multiply
     - parameter f2: Fraction to multiply by
     
     - returns: The result of f1*f2.
     */
    static func multiply(_ f1: Fraction, by f2: Fraction) -> Fraction {
        return f1.multiply(f2)
    }
    
    /**
     Divide a fraction by fraction.
     
     - parameter f1: Fraction to divide
     - parameter f2: Fraction to divide by
     
     - returns: The result of f1/f2.
     */
    static func divide(_ f1: Fraction, by f2: Fraction) -> Fraction {
        return f1.divide(f2)
    }
    
    /**
     Adds an integer to self.
     
     - parameter x: Integer to add to self
     
     - returns: Fraction The result of adding x to self.
     */
    func add(_ x: Int) -> Fraction {
        return Fraction(num: self.num + self.den*x,
                        den: self.den)
    }
    
    /**
     Subtracts an integer from self.
     
     - parameter x: Integer to subtract from self
     
     - returns: Fraction The result of subtracting x from self.
     */
    func subtract(_ x: Int) -> Fraction {
        return Fraction(num: self.num - self.den*x,
                        den: self.den)
    }
    
    /**
     Multiplies self by an integer.
     
     - parameter x: Integer to multiply self by
     
     - returns: Fraction The result of multiplying self by x.
     */
    func multiply(_ x: Int) -> Fraction {
        return Fraction(num: self.num*x, den: self.den)
    }
    
    /**
     Divides self by an integer.
     
     - parameter x: Integer to divide self by
     
     - returns: Fraction The result of dividing self by x.
     */
    func divide(_ x: Int) -> Fraction {
        return Fraction(num: self.num, den: self.den*x)
    }
    
    /**
     Reduce self by greatest common denominator found.
     */
    private func reduce() {
        if(den < 0) {
            // If the denominator is negative
            // multiply the numerator and
            // denominator by -1 - this
            // ensures the denominator is
            // always positive, and numerator
            // carries the appropriate sign
            num = -num
            den = -den
        }
        
        // Find greatest common denominator
        for gcd in (1...den).reversed() {
            if(num%gcd == 0 && den%gcd==0) {
                // Common denominator found,
                // divide numerator and denominator
                num /= gcd
                den /= gcd
                break
            }
        }
    }
}

/**
 + operator between two Fractions
 */
func +(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.add(f2)
}

/**
 - operator between two Fractions
 */
func -(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.subtract(f2)
}

/**
 * operator between two Fractions
 */
func *(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.multiply(f2)
}

/**
 / operator between two Fractions
 */

func /(f1: Fraction, f2: Fraction) -> Fraction {
    return f1.divide(f2)
}
