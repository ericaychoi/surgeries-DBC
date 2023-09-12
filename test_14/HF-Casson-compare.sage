#docker pull computop/sage

#docker run -it --mount type=bind,source="G:\My Drive\Summer Research 2020\Data\3to12n\14test",target=/home/sage/linux_share computop/sage

#sage

import snappy
import regina
import math

f = open('linux_share/test_14/knotList.txt', 'r')
knotList = f.readlines()
f.close()

f = open('linux_share/test_14/detList.txt', 'r')
detList = f.readlines()
f.close()

f = open('linux_share/test_14/mList.txt', 'r')
mList = f.readlines()
f.close()

f = open('linux_share/test_14/nList.txt', 'r')
nList = f.readlines()
f.close()

f = open('linux_share/test_14/HFboundList.txt', 'r')
HFboundList = f.readlines()
f.close()

f = open('linux_share/test_14/cassonList.txt', 'r')
cassonList = f.readlines()
f.close()

f = open('linux_share/test_14/aList.txt', 'r')
aList = f.readlines()
f.close()
from sage.misc.parser import Parser
par = Parser()

f = open('linux_share/test_14/DTList.txt', 'r')
DTList = f.readlines()
f.close()

def DTconvertFull(dt):
     new_dt = "DT:["
     for x in dt:
         if x == "\n":
             y = ""
         elif ord(x) > 95:
             y = 2 * (ord(x) - 96)
             y1 = str(y) + ","
             new_dt += str(y1)
         else:
             y = -2 * (ord(x) - 64)
             y1 = str(y) + ","
             new_dt += str(y1)
     if new_dt[len(new_dt)-1] == ",":
             new_dt = new_dt[:-1]
     new_dt += "]"
     return new_dt

def function1(input):
  if (math.floor(input) == input):
    input = 0
  else:
    input = input - math.floor(input) - 1/2
  return input

def dedekind(q,p):
  sum = 0
  for k in range(1, abs(p)):
    sum = sum + (function1(k/p) * function1(k*q/p))
  return sum

def rank(m,n,p,q):
      return abs(p-m*q)+n*abs(q)

def minRank(m,n,p):
      if (m == 0):
          mini = abs(p) + n  # If m=0, then rank is |p|+ n|q|, but q is a nonzero integer, so minimized at q=1
      else:
          q1 = 1
          q2 = -1
          sing = p/m
          if (abs(p/m) < 1):
              mini = min(rank(m,n,p,q1),rank(m,n,p,q2))
          else:
              q3 = math.floor(sing)
              q4 = math.ceil(sing)
              mini = min(rank(m,n,p,q1),rank(m,n,p,q2),rank(m,n,p,q3),rank(m,n,p,q4))
      return mini

def qminus(HFbound,p,m,n):
    if m == 0:
        HFsing = 0
    else:
        HFsing = n*abs(p/m)
    if (m == -n and HFbound == HFsing):
        qtemp = ceil(p/m)
        if qtemp == 0:
            return 1
        else:
            return qtemp
    elif (m < 0 and HFbound > HFsing):
        qtemp = ceil((HFbound + p)/(m-n))
        if qtemp == 0:
            return 1
        else:
            return qtemp
    else:
        qtemp = ceil(-(HFbound - p)/(m+n))
        if qtemp == 0:
            return 1
        else:
            return qtemp

def qplus(HFbound,p,m,n):
    if m == 0:
        HFsing = 0
    else:
        HFsing = n*abs(p/m)
    if (m == n and HFbound == HFsing):
        qtemp = floor(p/m)
        if qtemp == 0:
            return -1
        else:
            return qtemp
    elif (m > 0 and HFbound > HFsing):
        qtemp = floor((HFbound + p)/(m+n))
        if qtemp == 0:
            return -1
        else:
            return qtemp
    else:
        qtemp = floor(-(HFbound - p)/(m-n))
        if qtemp == 0:
            return -1
        else:
            return qtemp


output_log = []
fail_log = []

for k in range(0,len(knotList)):
          if (k % 1000 == 0):
              print(k/len(knotList))
          p = abs(par.parse(detList[k].strip("\n")))
          m = par.parse(mList[k].strip("\n"))
          n = par.parse(nList[k].strip("\n"))
          mini = minRank(m,n,p)
          HFbound = par.parse(HFboundList[k].strip("\n")) #Recall that HFbound is an upper bound for HF of DBC.
          turaevViroCalculated = 0
          if (mini <= HFbound):
              temp = 'Heegaard Floer obstruction fails for '+str(knotList[k])+' : minRank = '+str(mini)+' but HFbound = '+str(HFbound)+"; m = "+str(m)+", n = "+str(n)+", p = "+str(p)
              output_log.append(temp)
              cassonDBC = Rational(cassonList[k].strip("\n"))
              fail = 0
              fail_values = []
              for q in [x for x in range(qminus(HFbound,p,m,n),qplus(HFbound,p,m,n)+1) if ((x != 0) and (gcd(x,p) == 1))]: 
                  aval = par.parse(aList[k].strip("\n"))
                  cassonSurgery = Rational(q*aval / p - dedekind(q,p)/2)
                  if (abs(cassonSurgery) == abs(cassonDBC)):
                      fail = 1
                      fail_values.append(q)
              if fail == 0:
                  temp='Successfully distinguished by Casson invariants.'
                  output_log.append(temp)
              if fail == 1:
                  fail_description = str(knotList[k])+"; "+DTconvertFull(DTList[k])+"; p = "+str(p)+"; q = "+str(fail_values)
                  fail_log.append(str(fail_description).replace("\n"," "))
          else:
              temp='Heegaard Floer obstruction succeeds for k = '+str(k)+' : minRank = '+str(mini)+' but HFbound = '+str(HFbound)
              output_log.append(temp)

with open('linux_share/test_14/Casson-comparison-results.txt', 'w') as outfile:
    outfile.write("\n".join(output_log))

with open('linux_share/test_14/failList.txt', 'w') as outfile:
    outfile.write("\n".join(fail_log))