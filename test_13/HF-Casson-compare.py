

# This file was *autogenerated* from the file linux_share/test_13/HF-Casson-compare.sage
from sage.all_cmdline import *   # import sage library

_sage_const_95 = Integer(95); _sage_const_2 = Integer(2); _sage_const_96 = Integer(96); _sage_const_64 = Integer(64); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_1000 = Integer(1000)#docker pull computop/sage

#docker run -it --mount type=bind,source="G:\My Drive\Summer Research 2020\Data\3to12n\14test",target=/home/sage/linux_share computop/sage

#sage

import snappy
import regina
import math

f = open('linux_share/test_13/knotList.txt', 'r')
knotList = f.readlines()
f.close()

f = open('linux_share/test_13/detList.txt', 'r')
detList = f.readlines()
f.close()

f = open('linux_share/test_13/mList.txt', 'r')
mList = f.readlines()
f.close()

f = open('linux_share/test_13/nList.txt', 'r')
nList = f.readlines()
f.close()

f = open('linux_share/test_13/HFboundList.txt', 'r')
HFboundList = f.readlines()
f.close()

f = open('linux_share/test_13/cassonList.txt', 'r')
cassonList = f.readlines()
f.close()

f = open('linux_share/test_13/aList.txt', 'r')
aList = f.readlines()
f.close()
from sage.misc.parser import Parser
par = Parser()

f = open('linux_share/test_13/DTList.txt', 'r')
DTList = f.readlines()
f.close()

def DTconvertFull(dt):
     new_dt = "DT:["
     for x in dt:
         if x == "\n":
             y = ""
         elif ord(x) > _sage_const_95 :
             y = _sage_const_2  * (ord(x) - _sage_const_96 )
             y1 = str(y) + ","
             new_dt += str(y1)
         else:
             y = -_sage_const_2  * (ord(x) - _sage_const_64 )
             y1 = str(y) + ","
             new_dt += str(y1)
     if new_dt[len(new_dt)-_sage_const_1 ] == ",":
             new_dt = new_dt[:-_sage_const_1 ]
     new_dt += "]"
     return new_dt

def function1(input):
  if (math.floor(input) == input):
    input = _sage_const_0 
  else:
    input = input - math.floor(input) - _sage_const_1 /_sage_const_2 
  return input

def dedekind(q,p):
  sum = _sage_const_0 
  for k in range(_sage_const_1 , abs(p)):
    sum = sum + (function1(k/p) * function1(k*q/p))
  return sum

def rank(m,n,p,q):
      return abs(p-m*q)+n*abs(q)

def minRank(m,n,p):
      if (m == _sage_const_0 ):
          mini = abs(p) + n  # If m=0, then rank is |p|+ n|q|, but q is a nonzero integer, so minimized at q=1
      else:
          q1 = _sage_const_1 
          q2 = -_sage_const_1 
          sing = p/m
          if (abs(p/m) < _sage_const_1 ):
              mini = min(rank(m,n,p,q1),rank(m,n,p,q2))
          else:
              q3 = math.floor(sing)
              q4 = math.ceil(sing)
              mini = min(rank(m,n,p,q1),rank(m,n,p,q2),rank(m,n,p,q3),rank(m,n,p,q4))
      return mini

def qminus(HFbound,p,m,n):
    if m == _sage_const_0 :
        HFsing = _sage_const_0 
    else:
        HFsing = n*abs(p/m)
    if (m == -n and HFbound == HFsing):
        qtemp = ceil(p/m)
        if qtemp == _sage_const_0 :
            return _sage_const_1 
        else:
            return qtemp
    elif (m < _sage_const_0  and HFbound > HFsing):
        qtemp = ceil((HFbound + p)/(m-n))
        if qtemp == _sage_const_0 :
            return _sage_const_1 
        else:
            return qtemp
    else:
        qtemp = ceil(-(HFbound - p)/(m+n))
        if qtemp == _sage_const_0 :
            return _sage_const_1 
        else:
            return qtemp

def qplus(HFbound,p,m,n):
    if m == _sage_const_0 :
        HFsing = _sage_const_0 
    else:
        HFsing = n*abs(p/m)
    if (m == n and HFbound == HFsing):
        qtemp = floor(p/m)
        if qtemp == _sage_const_0 :
            return -_sage_const_1 
        else:
            return qtemp
    elif (m > _sage_const_0  and HFbound > HFsing):
        qtemp = floor((HFbound + p)/(m+n))
        if qtemp == _sage_const_0 :
            return -_sage_const_1 
        else:
            return qtemp
    else:
        qtemp = floor(-(HFbound - p)/(m-n))
        if qtemp == _sage_const_0 :
            return -_sage_const_1 
        else:
            return qtemp


output_log = []
fail_log = []

for k in range(_sage_const_0 ,len(knotList)):
          if (k % _sage_const_1000  == _sage_const_0 ):
              print(k/len(knotList))
          p = abs(par.parse(detList[k].strip("\n")))
          m = par.parse(mList[k].strip("\n"))
          n = par.parse(nList[k].strip("\n"))
          mini = minRank(m,n,p)
          HFbound = par.parse(HFboundList[k].strip("\n")) #Recall that HFbound is an upper bound for HF of DBC.
          turaevViroCalculated = _sage_const_0 
          if (mini <= HFbound):
              temp = 'Heegaard Floer obstruction fails for '+str(knotList[k])+' : minRank = '+str(mini)+' but HFbound = '+str(HFbound)+"; m = "+str(m)+", n = "+str(n)+", p = "+str(p)
              output_log.append(temp)
              cassonDBC = Rational(cassonList[k].strip("\n"))
              fail = _sage_const_0 
              fail_values = []
              for q in [x for x in range(qminus(HFbound,p,m,n),qplus(HFbound,p,m,n)+_sage_const_1 ) if ((x != _sage_const_0 ) and (gcd(x,p) == _sage_const_1 ))]: 
                  aval = par.parse(aList[k].strip("\n"))
                  cassonSurgery = Rational(q*aval / p - dedekind(q,p)/_sage_const_2 )
                  if (abs(cassonSurgery) == abs(cassonDBC)):
                      fail = _sage_const_1 
                      fail_values.append(q)
              if fail == _sage_const_0 :
                  temp='Successfully distinguished by Casson invariants.'
                  output_log.append(temp)
              if fail == _sage_const_1 :
                  fail_description = str(knotList[k])+"; "+DTconvertFull(DTList[k])+"; p = "+str(p)+"; q = "+str(fail_values)
                  fail_log.append(str(fail_description).replace("\n"," "))
          else:
              temp='Heegaard Floer obstruction succeeds for k = '+str(k)+' : minRank = '+str(mini)+' but HFbound = '+str(HFbound)
              output_log.append(temp)

with open('linux_share/test_13/Casson-comparison-results.txt', 'w') as outfile:
    outfile.write("\n".join(output_log))

with open('linux_share/test_13/failList.txt', 'w') as outfile:
    outfile.write("\n".join(fail_log))
