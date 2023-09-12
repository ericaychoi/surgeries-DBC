#docker pull computop/sage

#docker run -it --mount type=bind,source="G:\My Drive\Summer Research 2020\Data\Master",target=/home/sage/linux_share computop/sage

#sage

import snappy
import regina
import math
import os.path
import copy

knotList = []
DTList = []
pList = []
qList = []


# Check if there's a working list of knots and slopes. If not, generate this working list based on the list of failed slopes (in "failList.txt") from HF-Casson-compare.

if (os.path.exists("linux_share/test_14/whatsLeft.txt") == False):
    with open('linux_share/test_14/failList.txt', 'r') as firstfile, open('linux_share/test_14/whatsLeft.txt', 'w') as secondfile:
        for line in firstfile:
            secondfile.write(line)

# Load the (existing) working list.

f = open('linux_share/test_14/whatsLeft.txt', 'r')
whatsLeftPrevious = f.readlines()
f.close()

# Now we'll make a new working list that eliminates any cases completed by a previous iteration of this script.

whatsLeft = []

for x in whatsLeftPrevious:
    if (x != "Done!\n"):
        whatsLeft.append(copy.deepcopy(x))
        data = x.strip("\n").split(";")
        knotList.append(data[0].strip(" "))
        DTList.append(data[1].strip(" "))
        pList.append(int(data[2].strip(" p = ")))
        qstrings = data[3].strip(" q = ").strip("[").strip("]").split(',')
        qvals = []
        for i in range(0,len(qstrings)):
            qvals.append(int(qstrings[i]))
        qList.append(qvals)

with open('linux_share/test_14/whatsLeft.txt', 'w') as outfile:
    outfile.writelines(whatsLeft)

progress_report = []
output_log = []



if (os.path.exists('linux_share/test_14/progress.txt') == False):
    with open('linux_share/test_14/progress.txt', 'w') as outfile:
        outfile.write("Preparing to compare Turaev-Viro invariants of DBC's and surgeries for the given knots.")

f = open('linux_share/test_14/progress.txt', 'r')
progressLines = f.readlines()
f.close()

# [Explain what's happening here.]

state1 = "[working on T-V invariant of DBC]"
state2 = "[working on T-V invariant of surgery]"
state0 = "[moving on to next knot]"

state = 0

if state1 in progressLines[-1]:
    state = 1

if state2 in progressLines[-1]:
    state = 2
    del progressLines[-1]

with open('linux_share/test_14/progress.txt', 'w') as outfile:
    outfile.writelines(progressLines)

newqList = copy.deepcopy(qList)

# [put comments in below to indicate when a progress update is happening.]

for k in range(0,len(knotList)):
    fail = 0
    p = pList[k]
    turaevViroCalculated = 0
    print(knotList[k])
    comment = "\n"+"Calculating Turaev-Viro invariants for K = "+str(knotList[k])
    progress_report.append(comment)
    if (state == 0):
        progressLines.append(comment+"\n")
        state = 1
        progressLines.append(state1)
        with open('linux_share/test_14/progress.txt', 'w') as outfile:
            outfile.writelines(progressLines)            
    K=snappy.Manifold(DTList[k])
    if (turaevViroCalculated == 0):
        C=K.covers(2)[0]
        C.dehn_fill((1,0),0)
        Cfill=C.filled_triangulation()
        isosigCover=Cfill.triangulation_isosig()
        CoverTri=regina.Triangulation3.fromIsoSig(isosigCover)
        CoverTri.intelligentSimplify()
        tvCover = CoverTri.turaevViro(5,alg=regina.ALG_TREEWIDTH)
        turaevViroCalculated = 1
        print(tvCover)
        comment = "T-V of DBC is "+str(tvCover)
        progress_report.append(comment)
        if (state == 1):
            progressLines[-1] = comment+"\n"
            state = 2
            with open('linux_share/test_14/progress.txt', 'w') as outfile:
                outfile.writelines(progressLines)            
    for q in qList[k]:
        progressLines.append(state2)
        with open('linux_share/test_14/progress.txt', 'w') as outfile:
            outfile.writelines(progressLines)
        state = 2
        Y=K
        Y.dehn_fill((p,q),0)
        Yfill=Y.filled_triangulation()
        isosigSurgery=Yfill.triangulation_isosig()
        SurgeryTri=regina.Triangulation3.fromIsoSig(isosigSurgery)
        SurgeryTri.intelligentSimplify()
        tvSurgery = SurgeryTri.turaevViro(5,alg=regina.ALG_TREEWIDTH)
        print(tvSurgery)
        comment = "T-V of surgery with q = "+str(q)+" is "+str(tvSurgery)
        progress_report.append(comment)
        progressLines[-1] = comment+"\n"
        with open('linux_share/test_14/progress.txt', 'w') as outfile:
            outfile.writelines(progressLines)
        if (tvSurgery == tvCover):
            if fail == 0:
                fail_values = []
            temp='Failed to distinguish using Turaev-Viro invariants; for q = '+str(q)+'; both Turaev-Viro invariants equal'+str(tvSurgery)
            output_log.append(temp)
            with open('linux_share/test_14/progress.txt', 'a') as outfile:
                outfile.write("\n")
                outfile.write(temp)
            fail = 1
            fail_values.append(q)
        else:
            newqList[k].remove(q)
            whatsLeft[k] = str(knotList[k])+"; "+DTList[k]+"; p = "+str(p)+"; q = "+str(newqList[k])+"\n"
            with open('linux_share/test_14/whatsLeft.txt', 'w') as outfile:
                outfile.writelines(whatsLeft)
        if newqList[k] == []:
            whatsLeft[k] = "Done!"+"\n"
            with open('linux_share/test_14/whatsLeft.txt', 'w') as outfile:
                outfile.writelines(whatsLeft)
    if fail == 0:
        progressLines.append("Successfully distinguished remaining surgeries from DBC."+"\n")
        with open('linux_share/test_14/progress.txt', 'w') as outfile:
            outfile.writelines(progressLines)
    state = 0
