//
//  AKBalance.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Adjusts one audio signal according to the values of another.

This operation outputs a version of the audio source, amplitude-modified so that its rms power is equal to that of the comparator audio source. Thus a signal that has suffered loss of power (eg., in passing through a filter bank) can be restored by matching it with, for instance, its own source. It should be noted that this modifies amplitude only; output signal is not altered in any other respect.
*/
@objc class AKBalance : AKParameter {

    // MARK: - Properties

    private var bal = UnsafeMutablePointer<sp_bal>.alloc(1)
    private var bal2 = UnsafeMutablePointer<sp_bal>.alloc(1)

    private var input = AKParameter()

    private var comparator = AKParameter()



    // MARK: - Initializers

    /** Instantiates the balance with default values

    - parameter input: Input audio signal. 
    - parameter comparator: Input audio signal. 
    */
    init(_ input: AKParameter, comparator: AKParameter)
    {
        super.init()
        self.input = input
        self.comparator = comparator
        setup()
        dependencies = [input, comparator]
        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal balance */
    internal func bindAll() {
    }

    /** Internal set up function */
    internal func setup() {
        sp_bal_create(&bal)
        sp_bal_create(&bal2)
        sp_bal_init(AKManager.sharedManager.data, bal)
        sp_bal_init(AKManager.sharedManager.data, bal2)
    }

    /** Computation of the next value */
    override func compute() {
        sp_bal_compute(AKManager.sharedManager.data, bal, &(input.leftOutput), &(comparator.leftOutput), &leftOutput);
        sp_bal_compute(AKManager.sharedManager.data, bal2, &(input.rightOutput), &(comparator.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_bal_destroy(&bal)
        sp_bal_destroy(&bal2)
    }
}
