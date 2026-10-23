// Recovered behavior from the fixed Google Pinyin ARM64 key-generator routines.
// Google-derived material keeps the rights boundary stated in NOTICE.
#ifndef COMEBACK_RECOVERED_SCORE_MATH_H
#define COMEBACK_RECOVERED_SCORE_MATH_H

namespace comeback::recovered {

// Original 0x18c56c and the inlined scale conversion at 0x18fc10.
// Finite native score domain, original FMADD/table arithmetic, normal rounding;
// not std::exp or a claim of complete overflow/underflow/ARM equivalence.
float ExpLogScore(float value);

// Add two finite logarithmic scores using the original lookup-table arithmetic.
// This is a scalar research component, not a complete decoder or ranking model.
float AddLogScores(float left, float right);

}  // namespace comeback::recovered
#endif
