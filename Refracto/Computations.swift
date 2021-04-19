//  Computations.swift - Refractometer Computations
//
//  Refractometer formula "Standard" is according Louis K. Bonham:
//  "The Use of Handheld Refractometers by Homebrewers" in the Zymurgy January/February 2001
//
//  Refractometer formulas of Petr Novotný:
//  http://www.diversity.beer/2017/01/pocitame-nova-korekce-refraktometru.html
//
//  Refractometer formulas of Sean Terrill:
//  http://seanterrill.com

import Foundation


// MARK: - Plato/SG Conversion

func plato(forSpecificGravity SG: Double) -> Double {
    return 668.72 * SG - 463.37 - 205.347 * pow(SG, 2)
}

func specificGravity(forPlato plato: Double) -> Double {
    return 1 + plato / (258.6 - plato * 227.1 / 258.2)
}


// MARK: - Refractometer Computation

func apparentSpecificGravity(forInitialRefraction initial: Double, finalRefraction final: Double, wortCorrection: Double, formula: RefractometerFormula) -> Double {
    guard initial >= final else { return .nan }

    let initialAdjusted = initial / wortCorrection
    let finalAdjusted = final / wortCorrection
    let result: Double

    switch(formula) {
    case .Standard:
        result = 1.001843
                 - 0.002318474 * initialAdjusted
                 - 0.000007775 * pow(initialAdjusted, 2)
                 - 0.000000034 * pow(initialAdjusted, 3)
                 + 0.00574     * final
                 + 0.00003344  * pow(final, 2)
                 + 0.000000086 * pow(final, 3)

    case .NovotnyLinear:
        result = 1.0
                 - 0.002349 * initialAdjusted
                 + 0.006276 * finalAdjusted

    case .NovotnyQuadratic:
        result = 1.0
                 + 0.00001335 * pow(initialAdjusted, 2)
                 - 0.00003239 * initialAdjusted * finalAdjusted
                 + 0.00002916 * pow(finalAdjusted, 2)
                 - 0.002421   * initialAdjusted
                 + 0.006219   * finalAdjusted

    case .TerrillLinear:
        result = 1.0
                 - 0.000856829 * initialAdjusted
                 + 0.00349412  * finalAdjusted

    case .TerrillCubic:
        result = 1.0
                 - 0.0044993     * initialAdjusted
                 + 0.000275806   * pow(initialAdjusted, 2)
                 - 0.00000727999 * pow(initialAdjusted, 3)
                 + 0.0117741     * finalAdjusted
                 - 0.00127169    * pow(finalAdjusted, 2)
                 + 0.0000632929  * pow(finalAdjusted, 3)
    }

    return result >= 1.0 ? result : .nan
}

func actualSpecificGravity(forApparentSpecificGravity gravity: Double, initialRefraction initial: Double, wortCorrection: Double) -> Double {
    guard gravity.isNormal else { return .nan }

    let initialAdjusted = initial / wortCorrection
    let actual = 0.1808 * initialAdjusted + 0.8192 * plato(forSpecificGravity: gravity)
    return specificGravity(forPlato: actual)
 }


// MARK: - Attenuation Computation

func attenuation(forSpecificGravity gravity: Double, initialRefraction initial: Double, wortCorrection: Double) -> Double {
    guard gravity.isNormal else { return .nan }

    let initialAdjusted = initial / wortCorrection
    let attenuation = (1.0 - plato(forSpecificGravity: gravity) / initialAdjusted) * 100.0
    return max(0, min(100, attenuation))
 }


// MARK: - Alcohol Computation

func alcoholContent(forSpecificGravity gravity: Double, initialRefraction initial: Double, wortCorrection: Double) -> Double {
    guard gravity.isNormal else { return .nan }

    let initialAdjusted = initial / wortCorrection
    let actualExtract = 0.1808 * initialAdjusted + 0.8192 * plato(forSpecificGravity: gravity)
    let actualDensity = specificGravity(forPlato: actualExtract)
    let alcoholByWeight = (initialAdjusted - actualExtract) / (2.0665 - 0.010665 * initialAdjusted)
    let alcoholByVolume = alcoholByWeight * actualDensity / 0.7893
    return max(0, min(100, alcoholByVolume))
}
