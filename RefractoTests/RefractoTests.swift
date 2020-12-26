//  RefractoTests.swift

import XCTest
@testable import Refracto

class RefractoTests: XCTestCase {
    func testPlatoForSpecificGravity() throws {
        let fmt = Formatter.brix
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.000)),  "0.0")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.010)),  "2.6")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.020)),  "5.1")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.030)),  "7.6")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.040)), "10.0")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.050)), "12.4")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.060)), "14.7")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.070)), "17.1")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.080)), "19.3")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.090)), "21.6")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.100)), "23.8")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.110)), "25.9")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.120)), "28.0")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.130)), "30.1")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.140)), "32.1")
        XCTAssertEqual(fmt.formattedString(for: plato(forSpecificGravity: 1.150)), "34.1")
    }

    func testSpecificGravityForPlato() throws {
        let fmt = Formatter.SG
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  0.0)), "1.000\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  1.0)), "1.004\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  2.0)), "1.008\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  3.0)), "1.012\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  4.0)), "1.016\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  5.0)), "1.020\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  6.0)), "1.024\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  7.0)), "1.028\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  8.0)), "1.032\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato:  9.0)), "1.036\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 10.0)), "1.040\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 11.0)), "1.044\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 12.0)), "1.048\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 13.0)), "1.053\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 14.0)), "1.057\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 15.0)), "1.061\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 16.0)), "1.065\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 17.0)), "1.070\u{2009}SG")
        XCTAssertEqual(fmt.formattedString(for: specificGravity(forPlato: 18.0)), "1.074\u{2009}SG")
    }

    func testApparentSpecificGravity() throws {
        let fmt = Formatter.formatter("#0.000000")
        let testData: [(RefractometerFormula, String)] = [
            (.Standard,      "1.010195"),
            (.TerrillCubic,  "1.011878"),
            (.TerrillLinear, "1.010957") ]

        for (formula, result) in testData {
            let x = apparentSpecificGravity(forInitialRefraction: 12.8, finalRefraction: 6.4, wortCorrection: 1.04, formula: formula)
            XCTAssertEqual(fmt.formattedString(for:x), result)
        }
    }

    func testApparentPlatoMMuM() throws {
        let fmt = Formatter.formatter("#0.0")
        let testData = [
            (12.8,  6.4, "2.8", "2.5"),
            (13.0,  6.0, "2.4", "1.8"),
            (14.0,  8.0, "4.0", "4.3"),
            (14.0,  7.0, "3.1", "2.7"),
            (11.0, 10.0, "6.3", "9.3"),
            (11.0,  9.0, "5.4", "7.7"),
            (11.0,  8.0, "4.6", "6.1"),
            (11.0,  7.0, "3.7", "4.6"),
            (11.0,  6.0, "2.9", "3.0"),
            ( 9.0,  6.0, "3.3", "4.2"),
            (21.0, 11.0, "5.0", "4.7") ]

        for (initial, final, res_terrill, res_standard) in testData {
            let pt = plato(forSpecificGravity: apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .TerrillLinear))
            XCTAssertEqual(fmt.formattedString(for:pt), res_terrill)

            let ps = plato(forSpecificGravity: apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .Standard))
            XCTAssertEqual(fmt.formattedString(for:ps), res_standard)
        }
    }

    func testActualSpecificGravity() throws {
        let fmt = Formatter.formatter("#0.000000")
        let testData: [(RefractometerFormula, String)] = [
            (.Standard,      "1.017134"),
            (.TerrillCubic,  "1.018528"),
            (.TerrillLinear, "1.017765") ]

        for (formula, result) in testData {
            let g = apparentSpecificGravity(forInitialRefraction: 12.8, finalRefraction: 6.4, wortCorrection: 1.04, formula: formula)
            let x = actualSpecificGravity(forApparentSpecificGravity: g, initialRefraction: 12.8, wortCorrection: 1.04)
            XCTAssertEqual(fmt.formattedString(for:x), result)
        }
    }

    func testActualPlatoMMuM() throws {
        let fmt = Formatter.formatter("#0.0")
        let testData = [
            (12.8,  6.4, "4.6", "4.3"),
            (13.0,  6.0, "4.3", "3.7"),
            (14.0,  8.0, "5.7", "6.0"),
            (14.0,  7.0, "5.0", "4.7"),
            (11.0, 10.0, "7.1", "9.5"),
            (11.0,  9.0, "6.4", "8.2"),
            (11.0,  8.0, "5.7", "7.0"),
            (11.0,  7.0, "5.0", "5.7"),
            (11.0,  6.0, "4.3", "4.4"),
            ( 9.0,  6.0, "4.3", "5.0"), // 4.3 5.1
            (21.0, 11.0, "7.8", "7.5") ]

        for (initial, final, res_terrill, res_standard) in testData {
            let gt = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .TerrillLinear)
            let pt = plato(forSpecificGravity: actualSpecificGravity(forApparentSpecificGravity: gt, initialRefraction: initial, wortCorrection: 1.03))
            XCTAssertEqual(fmt.formattedString(for:pt), res_terrill)

            let gs = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .Standard)
            let ps = plato(forSpecificGravity: actualSpecificGravity(forApparentSpecificGravity: gs, initialRefraction: initial, wortCorrection: 1.03))
            XCTAssertEqual(fmt.formattedString(for:ps), res_standard)
        }
    }

    func testAttenuation() throws {
        let fmt = Formatter.formatter("#0.000000")
        let testData: [(RefractometerFormula, String)] = [
            (.Standard,      "78.775530"),
            (.TerrillCubic,  "75.309677"),
            (.TerrillLinear, "77.205646") ]

        for (formula, result) in testData {
            let g = apparentSpecificGravity(forInitialRefraction: 12.8, finalRefraction: 6.4, wortCorrection: 1.04, formula: formula)
            let x = attenuation(forSpecificGravity: g, initialRefraction: 12.8, wortCorrection: 1.04)
            XCTAssertEqual(fmt.formattedString(for:x), result)
        }
    }

    func testAttenuationMMuM() throws {
        let fmt = Formatter.formatter("#00")
        let testData = [
            (12.8,  6.4, "77", "80"),
            (13.0,  6.0, "81", "86"),
            (14.0,  8.0, "71", "68"),
            (14.0,  7.0, "77", "80"),
            (11.0, 10.0, "41", "13"),
            (11.0,  9.0, "49", "28"),
            (11.0,  8.0, "57", "42"),
            (11.0,  7.0, "65", "57"),
            (11.0,  6.0, "73", "72"),
            ( 9.0,  6.0, "62", "52"),
            (21.0, 11.0, "75", "77") ]

        for (initial, final, res_terrill, res_standard) in testData {
            let gt = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .TerrillLinear)
            let xt = attenuation(forSpecificGravity: gt, initialRefraction: initial, wortCorrection: 1.03)
            XCTAssertEqual(fmt.formattedString(for:xt), res_terrill)

            let gs = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .Standard)
            let xs = attenuation(forSpecificGravity: gs, initialRefraction: initial, wortCorrection: 1.03)
            XCTAssertEqual(fmt.formattedString(for:xs), res_standard)
        }
    }

    func testAlcohol() throws {
        let fmt = Formatter.formatter("#0.000000")
        let testData = [
            (1.0119, "5.060091"),
            (1.0110, "5.180837"),
            (1.0102, "5.288166") ]

        for (gravity, res) in testData {
            let x = alcoholContent(forSpecificGravity: gravity, initialRefraction: 12.8, wortCorrection: 1.04)
            XCTAssertEqual(fmt.formattedString(for:x), res)
        }
    }

    func testAlcoholMMuM() throws {
        let fmt = Formatter.formatter("#0.0")
        let testData = [
            // MMuM ignores the density in the ABW computation, therefore Refracto computes slighty higher values...
            (12.8,  6.4, "5.2", "5.4"),  // 5.1 5.3
            (13.0,  6.0, "5.6", "5.9"),  // 5.5 5.8
            (14.0,  8.0, "5.3", "5.1"),  // 5.2 5.0
            (14.0,  7.0, "5.8", "6.0"),  // 5.7 5.9
            (11.0, 10.0, "2.4", "0.8"),  // 2.3 0.8
            (11.0,  9.0, "2.9", "1.6"),  // 2.8 1.6
            (11.0,  8.0, "3.3", "2.5"),  // 3.2 2.4
            (11.0,  7.0, "3.8", "3.3"),  // 3.7 3.2
            (11.0,  6.0, "4.2", "4.1"),  // 4.1 4.1
            ( 9.0,  6.0, "2.9", "2.4"),  // 2.9 2.4
            (21.0, 11.0, "8.9", "9.1") ] // 8.6 8.8

        for (initial, final, res_terrill, res_standard) in testData {
            let gt = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .TerrillLinear)
            let xt = alcoholContent(forSpecificGravity: gt, initialRefraction: initial, wortCorrection: 1.03)
            XCTAssertEqual(fmt.formattedString(for:xt), res_terrill)

            let gs = apparentSpecificGravity(forInitialRefraction: initial, finalRefraction: final, wortCorrection: 1.03, formula: .Standard)
            let xs = alcoholContent(forSpecificGravity: gs, initialRefraction: initial, wortCorrection: 1.03)
            XCTAssertEqual(fmt.formattedString(for:xs), res_standard)
        }
    }
}
