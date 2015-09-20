//
//  AKHighShelfParametricEqualizerFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** High Shelf Parametric Equalizer

This is an implementation of Zoelzer's parametric equalizer filter.
*/
@objc class AKHighShelfParametricEqualizerFilter : AKParameter {

    // MARK: - Properties

    private var pareq = UnsafeMutablePointer<sp_pareq>.alloc(1)
    private var pareq2 = UnsafeMutablePointer<sp_pareq>.alloc(1)

    private var input = AKParameter()


    /** Corner frequency. [Default Value: 1000] */
    var centerFrequency: AKParameter = akp(1000) {
        didSet {
            centerFrequency.bind(&pareq.memory.fc, right:&pareq2.memory.fc)
            dependencies.append(centerFrequency)
        }
    }

    /** Amount at which the center frequency value shall be increased or decreased. A value of 1 is a flat response. [Default Value: 1] */
    var gain: AKParameter = akp(1) {
        didSet {
            gain.bind(&pareq.memory.v, right:&pareq2.memory.v)
            dependencies.append(gain)
        }
    }

    /** Q of the filter. sqrt(0.5) is no resonance. [Default Value: 0.707] */
    var q: AKParameter = akp(0.707) {
        didSet {
            q.bind(&pareq.memory.q, right:&pareq2.memory.q)
            dependencies.append(q)
        }
    }

    /** EQ mode. 0 = peak, 1 = low shelving, 2 = high shelving [Default Value: 2] */
    var mode: AKParameter = akp(2) {
        didSet {
            mode.bind(&pareq.memory.mode, right:&pareq2.memory.mode)
            dependencies.append(mode)
        }
    }


    // MARK: - Initializers

    /** Instantiates the equalizer with default values

    - parameter input: Input audio signal. 
    */
    init(_ input: AKParameter)
    {
        super.init()
        self.input = input
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the equalizer with all values

    - parameter input: Input audio signal. 
    - parameter centerFrequency: Corner frequency. [Default Value: 1000]
    - parameter gain: Amount at which the center frequency value shall be increased or decreased. A value of 1 is a flat response. [Default Value: 1]
    - parameter q: Q of the filter. sqrt(0.5) is no resonance. [Default Value: 0.707]
    */
    convenience init(
        _ input:         AKParameter,
        centerFrequency: AKParameter,
        gain:            AKParameter,
        q:               AKParameter)
    {
        self.init(input)
        self.centerFrequency = centerFrequency
        self.gain            = gain
        self.q               = q

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal equalizer */
    internal func bindAll() {
        centerFrequency.bind(&pareq.memory.fc, right:&pareq2.memory.fc)
        gain           .bind(&pareq.memory.v, right:&pareq2.memory.v)
        q              .bind(&pareq.memory.q, right:&pareq2.memory.q)
        dependencies.append(centerFrequency)
        dependencies.append(gain)
        dependencies.append(q)
    }

    /** Internal set up function */
    internal func setup() {
        sp_pareq_create(&pareq)
        sp_pareq_create(&pareq2)
        sp_pareq_init(AKManager.sharedManager.data, pareq)
        sp_pareq_init(AKManager.sharedManager.data, pareq2)
    }

    /** Computation of the next value */
    override func compute() {
        sp_pareq_compute(AKManager.sharedManager.data, pareq, &(input.leftOutput), &leftOutput);
        sp_pareq_compute(AKManager.sharedManager.data, pareq2, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_pareq_destroy(&pareq)
        sp_pareq_destroy(&pareq2)
    }
}
