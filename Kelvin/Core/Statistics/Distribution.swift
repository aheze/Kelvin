//
//  OneVar.swift
//  Kelvin
//
//  Created by Jiachen Ren on 1/28/19.
//  Copyright © 2019 Jiachen Ren. All rights reserved.
//

import Foundation
import GameKit

/// Distribution
/// TODO: Confidence interval, margin of error.
/// Margin of error = z-score (from confidence interval) * stdev of sampling dist.
/// Confidence interval = estimate +/- margin of error.
public extension Stat {
    
    /// Internal function used by StudentCdf;
    /// Ported to Swift from Java implementation.
    ///
    /// - Source: https://github.com/datumbox/datumbox-framework/blob/develop/datumbox-framework-core/src/main/java/com/datumbox/framework/core/statistics/distributions/ContinuousDistributions.java
    private static func betinc(_ x: Float80, _ A: Float80, _ B: Float80) -> Float80{
        var A0: Float80 = 0.0
        var B0: Float80 = 1.0
        var A1: Float80 = 1.0
        var B1: Float80 = 1.0
        var M9: Float80 = 0.0
        var A2: Float80 = 0.0
        
        // The accuracy of the approximation
        let accuracy: Float80 = 0.0000001
        while (abs((A1 - A2) / A1) > accuracy) {
            A2 = A1
            var C9 = -(A + M9) * (A + B + M9) * x / (A + 2.0 * M9) / (A + 2.0 * M9 + 1.0)
            A0 = A1 + C9 * A0
            B0 = B1 + C9 * B0
            M9 = M9 + 1
            C9 = M9 * (B - M9) * x / (A + 2.0 * M9 - 1.0) / (A + 2.0 * M9)
            A1 = A0 + C9 * A1
            B1 = B0 + C9 * B1
            A0 = A0 / B1
            B0 = B0 / B1
            A1 = A1 / B1
            B1 = 1.0
        }
        
        return A1 / A
    }
    
    /// Calculates the probability from `-inf` to `x` under `tPdf`.
    /// Ported to Swift from Java implementation.
    ///
    /// - Source: https://github.com/datumbox/datumbox-framework/blob/develop/datumbox-framework-core/src/main/java/com/datumbox/framework/core/statistics/distributions/ContinuousDistributions.java
    ///
    /// - Parameters:
    ///     - x: The value at which tCdf is evaluated
    ///     - df: Degrees of freedom
    public static func tCdf(_ x: Float80, _ df: Int) throws -> Float80 {
        try Constraint.domain(df, 1, Float80.infinity)
        let df = Float80(df)
        let A: Float80 = df / 2.0
        let S: Float80 = A + 0.5
        let Z: Float80 = df / (df + x * x)
        let BT: Float80 = exp(
            logGamma(S) -
            logGamma(0.5) -
            logGamma(A) +
            A * log(Z) +
            0.5 * log(1.0 - Z)
        )
        
        let betacdf: Float80
        
        if  Z < (A + 1.0) / (S + 2.0) {
            betacdf = BT * betinc(Z, A, 0.5)
        }
        else {
            betacdf = 1 - BT * betinc(1.0 - Z, 0.5, A)
        }
        
        var tcdf: Float80
        if x < 0 {
            tcdf = betacdf / 2.0
        } else {
            tcdf = 1.0 - betacdf / 2.0
        }
        
        return tcdf
    }
    
    /// Calculates the probability from `lowerBound` to `upperBound` under `tPdf`.
    ///
    /// - Parameters:
    ///     - x: The value at which tCdf is evaluated
    ///     - df: Degrees of freedom
    public static func tCdf(lowerBound lb: Float80, upperBound ub: Float80, _ df: Int) throws -> Float80 {
        try Constraint.range(lb, ub)
        return try tCdf(ub, df) - tCdf(lb, df)
    }
    
    /// Internal log for gamma function used to compute tCdf.
    /// - SeeAlso: Gamma.logForGamma(_:)
    private static func logGamma(_ Z: Float80) -> Float80 {
        let S = 1 + 76.18009173 / Z - 86.50532033 /
            (Z + 1) + 24.01409822 /
            (Z + 2) - 1.231739516 /
            (Z + 3) + 0.00120858003 /
            (Z + 4) - 0.00000536382 /
            (Z + 5)
        return (Z - 0.5) * log(Z + 4.5) -
            (Z + 4.5) + log(S * 2.50662827465)
    }
    
    /// Student's t probability density function:
    /// tPdf(t,ν)= Γ((ν+1)/2)/(√(νπ)Γ(ν/2))*(1+t^2/ν)^(−1/2*(ν+1))
    ///
    /// - Parameters:
    ///     - t: The value where PDF is to be evaluated
    ///     - v: Degrees of freedom
    
    public static func tPdf(_ t: Float80, _ v: Int) throws -> Node {
        let v: Float80 = Float80(v)
        return try Gamma.gamma((v + 1) / 2.0) /
            (√(v * Float80.pi) * Gamma.gamma(v / 2)) *
            ((1 + (t ^ 2) / v) ^ ( -0.5 * (v + 1)))
    }
    
    /// Geometric probability function
    /// - Parameters:
    ///     - k: The first trial that is successful
    ///     - pr: Probability of success
    public static func geomPdf(prSuccess pr: Node, _ k: Int) throws -> Node {
        try Constraint.domain(k, 0, Float80.infinity)
        return pr * ((1 - pr) ^ (k - 1))
    }
    
    /// - Returns: Cumulative geometric probability distribution from `lowerBound` to `upperBound`
    public static func geomCdf(prSuccess pr: Node, lowerBound lb: Int, upperBound ub: Int) throws -> Node {
        try Constraint.domain(lb, 0, Float80.infinity)
        try Constraint.domain(ub, 0, Float80.infinity)
        try Constraint.range(lb, ub)
        return try (lb...ub).map {
            try geomPdf(prSuccess: pr, $0)
        }.reduce(0) {
            $0 + $1
        }
    }
    
    /// Binomial cummulative distribution
    public static func binomCdf(trials: Int, prSuccess pr: Node, lowerBound lb: Int, upperBound ub: Int) throws -> Node {
        try Constraint.domain(trials, 0, Float80.infinity)
        try Constraint.domain(lb, 0, trials)
        try Constraint.domain(ub, 0, trials)
        try Constraint.range(lb, ub)
        return (lb...ub).map {
            binomPdf(trials: trials, prSuccess: pr, $0)
        }.reduce(0) {
            $0 + $1
        }
    }
    
    /**
     Calculates probability for obtaining x number of successes, where x every
     an integer from 0 to number of trials.
     
     - Parameters:
        - trials: Number of trials to be carried out
        - prSuccess: A Float80 b/w 0 and 1 that is the probability of success
     */
    public static func binomPdf(trials: Int, prSuccess pr: Node) -> [Node] {
        return (0...trials).map {
            binomPdf(trials: trials, prSuccess: pr, $0)
        }
    }
    
    /**
     Calculates binominal probability distribution
     - Parameters:
        - trials: Number of trials to be carried out
        - prSuccess: A Float80 b/w 0 and 1 that is the probability of success
        - x: Number of successes
     - Returns: The probability of getting the specified number of successes.
     */
    public static func binomPdf(trials: Node, prSuccess pr: Node, _ x: Node) -> Node {
        return Function(.ncr, [trials, x]) * (pr ^ x) * ((1 - pr) ^ (trials - x))
    }
    
    /// A lightweight algorithm for calculating cummulative distribution frequency.
    public static func normCdf(_ x: Double) -> Double {
        var L: Double, K: Double, w: Double
        
        // Constants
        let a1 = 0.31938153, a2 = -0.356563782, a3 = 1.781477937
        let a4 = -1.821255978, a5 = 1.330274429
        
        L = fabs(x)
        K = 1.0 / (1.0 + 0.2316419 * L)
        w = 1.0 - 1.0 / sqrt(2 * .pi) * exp(-L * L / 2) * (a1 * K + a2 * K * K + a3 * pow(K, 3) + a4 * pow(K, 4) + a5 * pow(K, 5))
        
        if (x < 0 ){
            w = 1.0 - w
        }
        return w
    }
    
    /**
     Cummulative distribution frequency from lower bound to upper bound,
     where the normal curve is centered at zero with stdev of 1.
     
     - Parameters:
     - from: Lower bound
     - to: Upper bound
     - Returns: Cummulative distribution frequency from lowerbound to upperbound.
     */
    public static func normCdf(from lb: Double, to ub: Double) -> Double {
        return normCdf(ub) - normCdf(lb)
    }
    
    /**
     Cummulative distribution frequency from lower bound to upper bound,
     where the normal curve is centered at μ with stdev of σ.
     
     - Parameters:
     - from: Lower bound
     - to: Upper bound
     - μ: mean
     - σ: Standard deviation
     - Returns: Cummulative distribution frequency from lowerbound to upperbound.
     */
    public static func normCdf(from lb: Double, to ub: Double, μ: Double, σ: Double) -> Double {
        return normCdf((ub - μ) / σ) - normCdf((lb - μ) / σ)
    }
    
    /**
     Normal probability density function.
     Definition: 1 / √(2π) * e ^ (-1 / 2) ^ 2
     */
    public static func normPdf(_ x: Node) -> Node {
        return 1 / √(2 * "pi"&) * ("e"& ^ ((-1 / 2) * (x ^ 2)))
    }
    
    /**
     normalPdf(x,μ,σ)=1 / σ * normalPdf((x−μ) / σ)
     */
    public static func normPdf(_ x: Node, μ: Node, σ: Node) -> Node {
        return 1 / σ * normPdf((x - μ) / σ)
    }
    
    public static func randNorm(μ: Float80, σ: Float80, n: Int) -> [Float80] {
        let gaussianDist = GaussianDistribution(
            randomSource: GKRandomSource(),
            mean: Float(μ),
            deviation: Float(σ))
        return [Float80](repeating: 0, count: n).map {_ in
            Float80(gaussianDist.nextFloat())
        }
    }
    
    private class GaussianDistribution {
        private let randomSource: GKRandomSource
        let mean: Float
        let deviation: Float
        
        init(randomSource: GKRandomSource, mean: Float, deviation: Float) {
            precondition(deviation >= 0)
            self.randomSource = randomSource
            self.mean = mean
            self.deviation = deviation
        }
        
        func nextFloat() -> Float {
            guard deviation > 0 else { return mean }
            
            let x1 = randomSource.nextUniform() // A random number between 0 and 1
            let x2 = randomSource.nextUniform() // A random number between 0 and 1
            let z1 = sqrt(-2 * log(x1)) * cos(2 * Float.pi * x2) // z1 is normally distributed
            
            // Convert z1 from the Standard Normal Distribution to our Normal Distribution
            return z1 * deviation + mean
        }
    }
    
    /**
     Converts an area representing cummulative distribution frequency to its
     corresponding standard deviation. Of course I didn't come up with this
     beast myself!
     
     **Source:**
     
     https://stackedboxes.org/2017/05/01/acklams-normal-quantile-function/
     */
    public static func invNorm(_ p: Double) throws -> Double {
        try Constraint.domain(Float80(p), 0, 1)
        
        let a1 = -39.69683028665376
        let a2 = 220.9460984245205
        let a3 = -275.9285104469687
        let a4 = 138.3577518672690
        let a5 = -30.66479806614716
        let a6 = 2.50662827745
        
        let b1 = -54.47609879822406
        let b2 = 161.5858368580409
        let b3 = -155.6989798598866
        let b4 = 66.80131188771972
        let b5 = -13.2806815528
        
        let c1 = -0.007784894002430293
        let c2 = -0.3223964580411365
        let c3 = -2.400758277161838
        let c4 = -2.549732539343734
        let c5 = 4.374664141464968
        let c6 = 2.93816398269
        
        let d1 = 0.007784695709041462
        let d2 = 0.3224671290700398
        let d3 = 2.445134137142996
        let d4 = 3.754408661907416
        
        let p_low =  0.02425
        let p_high = 1 - p_low
        var q: Double, r: Double, e: Double, u: Double
        var x = 0.0
        
        // Rational approximation for lower region.
        if (0 < p && p < p_low) {
            q = sqrt(-2 * log(p))
            x = (((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) / ((((d1 * q + d2) * q + d3) * q + d4) * q + 1)
        }
        
        // Rational approximation for central region.
        if (p_low <= p && p <= p_high) {
            q = p - 0.5
            r = q * q
            x = (((((a1 * r + a2) * r + a3) * r + a4) * r + a5) * r + a6) * q / (((((b1 * r + b2) * r + b3) * r + b4) * r + b5) * r + 1)
        }
        
        // Rational approximation for upper region.
        if (p_high < p && p < 1) {
            q = sqrt(-2 * log(1 - p))
            x = -(((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) / ((((d1 * q + d2) * q + d3) * q + d4) * q + 1)
        }
        
        if 0 < p && p < 1 {
            e = 0.5 * erfc(-x / sqrt(2)) - p
            u = e * sqrt(2 * .pi) * exp(x * x / 2)
            x = x - u / (1 + x * u / 2)
        }
        
        return x
    }
}
