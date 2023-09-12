#docker pull computop/sage

#docker run -it --mount type=bind,source="G:\My Drive\Summer Research 2020\Data\Master",target=/home/sage/linux_share computop/sage

#sage

print("Starting up")

import snappy
import regina

import sympy as sym
from symbol import *
import math

print("Loading knot names and DT codes.")

f = open("linux_share/test_3-12/DTList.txt", "r")
DTList = f.readlines()
f.close()

f = open("linux_share/test_3-12/numDTList.txt", "r")
numDTList = f.readlines()
f.close()

f = open("linux_share/test_3-12/knotList.txt", "r")
knotList = f.readlines()
f.close()

print("Total of "+str(len(knotList))+" knots in list.")

#test with: K=regina.Link.fromDT(DTList[0].strip("\n"))

def clean(input):
#     return sym.parse_expr(str(input).replace('^','**').replace('+ x','+x').replace('- x','-x').replace(' x','*x').replace('+ y','+y').replace('- y','-y').replace(' y','*y'))
     return sym.parse_expr(str(input).replace('^','**').replace('+ ','+').replace('- ','-').replace(' x','*x').replace(' y','*y'))

#Can we just replace '+ ' with '+' and '- ' with '-' instead of doing it twice with variables?

def normalize(input):
    return input.subs(x,sqrt(x))

def snappyDT(dt):
    return "DT: [("+dt+")]"

K=snappy.Link(snappyDT(numDTList[0].strip('\n')))

def alex(K):
    homfly = K.homflyAZ()
    return sym.parse_expr(str(clean(K.homflyAZ()).subs(x,1)).replace('y','x')).subs(x,sqrt(x)-1/sqrt(x))
#line above seems faster without producing errors, but saving the older versions below just in case for now
#    return sym.simplify(sym.parse_expr(str(clean(K.homflyAZ()).subs(x,1)).replace('y','x')).subs(x,sqrt(x)-1/sqrt(x)))
#    return clean(str(clean(K.homflyAZ()).subs(x,1)).replace('y','x')).subs(x,sqrt(x)-1/sqrt(x))
#    return sym.expand(sym.simplify(clean(str(clean(K.homflyAZ()).subs(x,1)).replace('y','x')).subs(x,sqrt(x)-1/sqrt(x))))

def Avalue(alex):
    dalex = sym.diff(alex, x)
    ddalex = sym.diff(dalex, x)
    a = 1/2 * ddalex.subs(x,1)
    return a

def det(alex):
    return alex.subs(x,-1)

alexList = []
detList = []
aList = []

print("Calculating Alexander polynomials, determinants, and A-values.")

for k in range(0,len(DTList)):
    K=regina.Link.fromDT(DTList[k].strip("\n"))
    g=alex(K)
    alexList.append(str(g))
    detList.append(str(det(g)))
    aList.append(str(Avalue(g)))
    if (k % 500 == 0) == True:
        print(str(k)+" ("+str(k/len(knotList))+")")

#If one wants to export the Alexander polynomials, one may want to apply sym.simplify(...) first. But then print using the following:

#with open("/home/sage/linux_share/test_3-12/alexList.txt", "w") as outfile:
#    outfile.write("\n".join(alexList))

with open("/home/sage/linux_share/test_3-12/detList.txt", "w") as outfile:
    outfile.write("\n".join(detList))

with open("/home/sage/linux_share/test_3-12/aList.txt", "w") as outfile:
    outfile.write("\n".join(aList))

#Calculate the signatures:

print("Calculating the signatures and Jones polynomials.")

K = snappy.Link(snappyDT(numDTList[0].strip("\n")))

sigList = []
jonesList = []

for k in range(0,len(knotList)):
    K = snappy.Link(snappyDT(numDTList[k].strip("\n")))
    sigList.append(K.signature())
    jonesList.append(clean(str(K.jones_polynomial()).replace('q','sqrt(x)')))
    if (k % 500 == 0) == True:
        print(str(k)+" ("+str(k/len(knotList))+")")

jonesListString = []
sigListString = []

for k in range(0,len(jonesList)):
    jonesListString.append(str(jonesList[k]))

for k in range(0,len(sigList)):
    sigListString.append(str(sigList[k]))

with open('/home/sage/linux_share/test_3-12/jonesList.txt','w') as outfile: 
    outfile.write('\n'.join(jonesListString))

with open('/home/sage/linux_share/test_3-12/sigList.txt','w') as outfile: 
    outfile.write('\n'.join(sigListString))

#Calculating the Casson invariants of the DBC's:

print("Preparing to calculate the Casson invariants of the double branched covers.")

jonesDerivList = []

for i in range(0,len(jonesList)):
    jonesDerivList.append(str(sym.diff(jonesList[i]).subs(x,-1)))
    if (i % 500 == 0):
        print(str(i)+" ("+str(i/len(knotList))+")")

deriv_list_clean = []
for i in range(0,len(jonesDerivList)):
     deriv_list_clean.append(int(jonesDerivList[i].strip('\n')))

print("Calculating the Casson invariants of the double branched covers.")

sig_list_clean = []
for i in range(0,len(sigList)):
     sig_list_clean.append(int(sigList[i]))

det_list_clean = []
for i in range(0,len(detList)):
     det_list_clean.append(int(detList[i].strip('\n')))

cassonCoverList = []
for i in range(0,len(knotList)):
    sig = Rational(sig_list_clean[i])
    deriv = Rational(deriv_list_clean[i])
    det = Rational(det_list_clean[i])
    casson = (sig/8) - ((deriv/det)/12)
    cassonCoverList.append(str(casson))
    if (i % 500 == 0):
        print(str(i)+" ("+str(i/len(knotList))+")")

with open('/home/sage/linux_share/test_3-12/cassonList.txt','w') as outfile: 
    outfile.write('\n'.join(cassonCoverList))