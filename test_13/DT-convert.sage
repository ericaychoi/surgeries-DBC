#docker pull computop/sage

#docker run -it --mount type=bind,source="G:\My Drive\Summer Research 2020\Data\Master",target=/home/sage/linux_share computop/sage

#sage

f = open("linux_share/test_13/DTList.txt", "r")
DTList = f.readlines()
f.close()

def DTconvert(dt):
     new_dt = ""
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
     return new_dt

numDTList = []

for dt in DTList:
    numDTList.append(DTconvert(dt))

with open('/home/sage/linux_share/test_13/numDTList.txt','w') as outfile: 
    outfile.write('\n'.join(numDTList))  