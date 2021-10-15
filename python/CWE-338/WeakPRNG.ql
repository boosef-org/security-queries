/**
 * @name Use of Cryptographically Weak Pseudo-Random Number Generator (PRNG)
 * @description Use of Cryptographically Weak Pseudo-Random Number Generator (PRNG).
 * @kind problem
 * @id py/weak-cryptographic-algorithm
 * @problem.severity warning
 * @security-severity 6.0
 * @sub-severity medium
 * @precision low
 * @tags security
 *       external/cwe/cwe-330
 *       external/cwe/cwe-338
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import DataFlow::PathGraph

abstract class RandomNumberGeneratorSinks extends DataFlow::Node { }

class OSRandom extends RandomNumberGeneratorSinks {
  OSRandom() {
    exists(DataFlow::Node call |
      call = API::moduleImport("os").getMember("getrandom").getACall() and this = call
    )
  }
}

class PyRandom extends RandomNumberGeneratorSinks {
  PyRandom() {
    exists(DataFlow::Node call |
      call = API::moduleImport("random").getMember("random").getACall() and this = call
    )
  }
}

from RandomNumberGeneratorSinks rngs
select rngs.asExpr(), "Using weak PRNG"
