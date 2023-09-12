# surgeries-DBC

This repository contains scripts and data needed to obstruct knots with 16 crossings or less whose $p/q$ Dehn surgery and double branched covering result in different 3-manifolds. The result of the algorithm shows that there is indeed no knot with 16 crossings or less whose Dehn surgery and double branched covering produces the same 3-manifold.

The following data files are needed to run the scripts:
- "DTList.txt" - A list of alphabetical DT codes.
- "knotList.txt" - A list of names for the knots.
- "mList.txt" - Hanselman's $m$-values for the knots.
- "nList.txt" - Hanselman's $n$-values for the knots.
- "HFboundList.txt" - A list of upper bounds on a rank of the Heegaard Floer homology of the knots' double branched covers. In some cases, the actual ranks are available (e.g., for knots with up through 12 crossings). In other cases, a weaker bound is substituted (e.g., the rank of Khovanov homology).

The scripts are intended to be run inside of the "computop" Docker environment via sage. (Commands for loading Docker with a bind to the correct directory are given at the top of the scripts.) The scripts should be run in the following order: 

DT-convert.sage &rarr; Classical-invariants.sage &rarr; HF-Casson-compare.sage &rarr; TV-compare.sage

### DT-convert.sage

This script converts the alphabetical DT codes in "DTList.txt" to numeric ones and saves them to a new file, "numDTList.txt".

### Classical-invariants.sage

This script calculates the Alexander polynomials, Jones polynomials, and signatures of the knots and uses these to produce five files that are needed for the later "HF-Casson-compare.sage" script:
- "detList.txt": A list of determinants of the knots (which determine $p$ for the surgery slopes $p/q$). Given by Alexander polynomial at -1.
- "aList.txt": The A-values of the knots (i.e., one half of the second derivative of the Alexander polynomial, evaluated at 1), which are used to compute Casson invariants of Dehn surgeries.
- "sigList.txt": The signatures of the knots.
- "jonesList.txt": The Jones polynomials of the knots (suitably normalized, as in the paper).
- "cassonList.txt": The Casson invariants of the knots' double branched covers, calculated using the signature and Jones polynomial via Mullins' formula.

### HF-Casson-compare.sage

This script eliminates all but finitely many surgeries to check for each knot. As a first pass, it uses Hanselman's data to calculate the rank of Heegaard Floer homology for surgeries as a function of $q$ (and $p=det(K)$). It compares this to the upper bound on the Heegaard Floer homology of the double branched cover of $K$, resulting in a finite interval of $q$-values. For each of these $q$-values, it calculates the Casson invariant of $p/q$-surgery and compares it to the pre-calculated Casson invariant of the double branched cover. If any $q$-values for which both obstructions are inconclusive are then saved to a file named "failList.txt".

### TV-compare.sage

This script attempts to distinguish the remaining surgeries from the double branched covers using Turaev-Viro invariants. These computations are resource-intensive and seem to accumulate memory, so the script is designed to be killed and restarted repeatedly. To accommodate this, it frequently saves progress reports ("progress.txt") and updated lists of which surgeries remain to be checked ("WhatsLeft.txt"). At the moment, its declarations of having "Successfully distinguished the remaining surgeries and double branched covers" are only valid if it checked the entire set of q-values without being halted. (Note: We will have to manually check to make sure there are no false negatives.) Any updates in the progress report that don't include this message (should) have at least one surgery that has the same Turaev-Viro invariants as the double branched cover, and this does indeed occur. Exceptions (because of failure to compute or equality in the Turaev-Viro invariants) have been saved to a file called "Check by hand.txt".