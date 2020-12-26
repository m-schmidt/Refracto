//  RefractometerModel.swift

import Foundation

final class RefractometerModel: NSObject {
    static var originalExtract: Double {
        let s = Settings.shared
        return s.initialRefraction / s.wortCorrection
    }

    static var originalGravity: Double {
        return specificGravity(forPlato: originalExtract)
    }

    static var apparentExtract: Double {
        return plato(forSpecificGravity: apparentGravity)
    }

    static var actualExtract: Double {
        return plato(forSpecificGravity: actualGravity)
    }

    static var apparentGravity: Double {
        let s = Settings.shared
        return apparentSpecificGravity(forInitialRefraction: s.initialRefraction, finalRefraction: s.finalRefraction, wortCorrection: s.wortCorrection, formula: s.formula)
    }

    static var actualGravity: Double {
        let s = Settings.shared
        return actualSpecificGravity(forApparentSpecificGravity: apparentGravity, initialRefraction: s.initialRefraction, wortCorrection: s.wortCorrection)
    }

    static var apparentAttenuation: Double {
        let s = Settings.shared
        return attenuation(forSpecificGravity: apparentGravity, initialRefraction: s.initialRefraction, wortCorrection: s.wortCorrection)
    }

    static var actualAttenuation: Double {
        let s = Settings.shared
        return attenuation(forSpecificGravity: actualGravity, initialRefraction: s.initialRefraction, wortCorrection: s.wortCorrection)
    }

    static var alcohol: Double {
        let s = Settings.shared
        return alcoholContent(forSpecificGravity: apparentGravity, initialRefraction: s.initialRefraction, wortCorrection: s.wortCorrection)
    }
}
