import itertools as it
import sys
import numpy as np
from matplotlib import pyplot as plt
import statistics
import time
from random import randint

def spAND(*inputsp):    #handles AND gates
    s = 1
    for inp in inputsp:
        s = s * inp 
    return s

def spOR(*inputsp):     #handles OR gates
    s = 1
    temp = 1
    for inp in inputsp:
        temp = temp * (1 - inp)
        s = 1 - temp
    return s

def sp2XOR(input1sp,input2sp):      #for creating the XOR gate
    #print("2XOR")
    s = input1sp*(1-input2sp) + (1-input1sp)*input2sp
    return s

def sp3XOR(*inputsp):
    #print("3XOR")
    leni = len(inputsp)
    temp = sp2XOR(inputsp[0],inputsp[1])
    for  i in range (2,leni):
        temp = sp2XOR(inputsp[i],temp)
    return temp


def spXOR(inputsp):       #handles XOR gates
    #print("Xor ",inputsp)
    #print("BIG XOR")
    leni = len(inputsp)
    if (leni == 1):
        print("Error with XOR")
    if (leni == 2):
        s = sp2XOR(inputsp[0],inputsp[1])
        return s
    else:
        temp = sp2XOR(inputsp[0],inputsp[1])
        for  i in range (2,leni):
            temp = sp2XOR(inputsp[i],temp)
        return temp

def spNAND(*inputsp):       #handles NAND gates
    s = 1
    temp = 1
    for inp in inputsp:
        temp = temp * inp
        s = 1 - temp
    return s

def spNOR(*inputsp):        #handles NOR gates
    s= 1
    for inp in inputsp:
        s = s * (1 - inp)
    return s

def sp2NOT(input1sp):       #handles NOT gates
    s = 1 - input1sp
    return s

def sp2XNOR(*inputsp):
    temp = sp2XOR(*inputsp)
    s = 1 - temp
    return s

def spXNOR(*inputsp):       #handles XNOR gates
    temp = spXOR(inputsp)
    s = 1 - temp
    return s

class element:                                                  #utilize the Element (gate)
    def __init__(self,ElementTypes,inputs, output,gate):
        self.ElementTypes = ElementTypes
        self.output = output
        #self.input = []
        #self.input.append(inputs)
        self.inputs = inputs
        self.gate = gate
    
# This function reads the files and return the correct position of inputs, final output and middle outputs to be used
    
def readF(file):                                                #function that reads the given txt file
    tempOut = []
    tempInp = []
    tempInp2 = []
    with open(file,'r') as f:
        head = f.readline()                                     #reads first line of file to find top_inputs
        chucks = head.split(' ')
        if (chucks[0] == 'top_inputs'):                         #if top_inputs is found go to mode 1, else mode 2
            print("Mode 1: Top inputs found!")                  #mode 1 handles the top_input from the first line
            for i in range(1,len(chucks)):
                TopInputs.append(chucks[i])                     #add top inputs to our Top array
                Top.append(chucks[i])    
            for line in f:
                data = line.split()
                lenData = len(data) 
                #####
                InputNumElements.append(lenData -2)
                #####
                ElementTypes.append(data[0])
                tempOut.append(data[1])
                TotalOutputsGL.append(data[1])
                for r1 in range(2,lenData):
                    TotalInputsGL.append(data[r1])
                    if data[r1] not in TopInputs:
                        tempInp.append(data[r1])                #tempInp = middle inputs
            Top.pop(len(Top)-1)                                 #remove \n symbol
            TopInputs.pop(len(TopInputs)-1)
            for n1 in tempOut:                                  # final output = never used as an input 
                if n1 not in tempInp:
                    Top.append(n1)
            for i in range(0,len(tempOut)):
                if tempOut[i] not in Top:
                    #print("In ",tempOut[i])
                    Top.append(tempOut[i])
                else:
                    print(tempOut[i])
            #for i in range(0,len(tempInp)):                     #add middle outputs (that are also middle inputs)
            #    Top.append(tempInp[i])
        else:
            print("Mode 2: Top inputs not included in file!")        #mode 2 finds the top_inputs (top_inputs are never used as outputs) 
            for line in f:
                data = line.split()
                lenData = len(data)
                InputNumElements.append(lenData -2)
                ElementTypes.append(data[0])
                tempOut.append(data[1])
                TotalOutputsGL.append(data[1])
                for r1 in range(2,lenData):
                    TotalInputsGL.append(data[r1])
                    tempInp.append(data[r1])
            for v in range(0,len(tempInp)):
                if tempInp[v] not in tempOut:                  #top inputs = never output so add them 
                    TopInputs.append(tempInp[v])
                    Top.append(tempInp[v])
            for ti in range(0,len(tempInp)):    
                if tempInp[ti] not in TopInputs:
                    tempInp2.append(tempInp[ti])               #remove top inputs from temp inputs 
            for n1 in tempOut:
                if n1 not in tempInp2:
                    Top.append(n1)
            for i in range(0,len(tempInp2)):
                Top.append(tempInp2[i])


    
    #print("TempINP",tempInp)
    #print("--",tempOut)
    #print("Top",Top)
    #print("TopInputs",TopInputs)
    	
def table(inputs):      #create truth table
    #print(inputs)
    for i in range(0,len(inputs)):
        SignalsTable[i] = inputs[i]
        
    return SignalsTable

def crElement(ElementTypes,TotalInputs,TotalOutputs,InputNumElements):
    ElementTable = []
    tempInputNumElements = []
    tempInputNumElements= InputNumElements.copy()                   #the number of inputs of each gate
    tempInputs = []
    #finalOutput = len(inputs) 
    output = 0
    inputNum = 0
    #for creating the elements
    for i in ElementTypes:                                          #we pick the gates one by one
        
        if ((len(TotalInputs) == 0) or (len(tempInputNumElements) == 0)):
            return ElementTable                             
        if (i != 'NOT'):

            numb = tempInputNumElements[0]                           
            for m in range(0,numb):                                     #so i can know how many inputs the gate has and remove(example 3 -> remove 3)
                inputNum = Top.index(TotalInputs[0])                    #position of inputs in Top
                tempInputs.append(inputNum)
                TotalInputs.pop(0)                                      #remove inputs
            
            
            output = Top.index(TotalOutputs[0])                     #position of output in Top
            
            E = element(i,tempInputs,output,tempInputNumElements[0])  #Element Type, output gate pos, inputs pos, num of inputs
            if E in ElementTable:
               continue
            else:
                ElementTable.append(E)
            TotalOutputs.pop(0)                                     #remove output from list
            tempInputNumElements.pop(0)
            tempInputs = []

        else:
            inputNum = Top.index(TotalInputs[0])
            tempInputs.append(inputNum)
            TotalInputs.pop(0)
            output = Top.index(TotalOutputs[0])
            
            E = element(i,tempInputs,output,tempInputNumElements[0])
            if E in ElementTable:
                continue
            else:
                ElementTable.append(E)
            TotalOutputs.pop(0)
            tempInputNumElements.pop(0)
            tempInputs = []
    

    return ElementTable

def process(element,signalTable):
    if(element.gate == 2):
        if(element.ElementTypes=='AND'):
            signalTable[element.output]=spAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='OR'):
            signalTable[element.output]=spOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='XOR'):
            signalTable[element.output]=sp2XOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='NAND'):
            signalTable[element.output]=spNAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='NOR'):
            signalTable[element.output]=spNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='XNOR'):
            signalTable[element.output]=spXNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        else:
            print("Error: Syntax error or unsupported type")
            exit(1)

        
    elif(element.gate == 3):
        if(element.ElementTypes=='AND'):
            signalTable[element.output]=spAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='OR'):
            signalTable[element.output]=spOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='XOR'):
            signalTable[element.output]=sp3XOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='NAND'):
            signalTable[element.output]=spNAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='NOR'):
            signalTable[element.output]=spNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='XNOR'):
            signalTable[element.output]=spXNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        else:
            print("Error: Syntax error or unsupported type")
            exit(1)

    elif(element.ElementTypes=='NOT'):
        signalTable[element.output]=sp2NOT(signalTable[element.inputs[0]])
        #print("NOT")

    elif(element.gate >= 4):
        #print("i am here")
        inputValList = []
        if(element.ElementTypes=='XOR'):
            for n in range(0,element.gate):
                inputValList.append(signalTable[element.inputs[n]])
            #print(tempoList)
            signalTable[element.output] = spXOR(inputValList)
        else:
            print("error with input number")
            exit(1)
    
    else:
        print("Error: Syntax error or unsupported type")

def findEsw(signal):
    s = 2*signal*(1-signal)
    return s

def createWorkload(inp, L):                         #create random workload 
    wl = []

    lenInp = len(inp)
    for y in range(0,L):
        ls = []
        for i in range(0,lenInp):
            w = np.random.choice([0,1])
            ls.append(w)
        wl.append(ls)
    #print(wl)
    return wl

def calcScore(SigTableBefore,SigTableCur):          #calculate score of workload (total switches)
    skip = len(TopInputs)                           #skip top inputs
    score = 0
    for i in range(skip,len(SigTableBefore)):
        #print("num ",i)
        if (SigTableBefore[i] != SigTableCur[i]):
            score+=1
    #print(score)
    return score

def makeGraph(N, totalSw):                          #make graph for 4.1
    x = np.arange(N)
    y = np.array(totalSw)
    plt.xlabel("Individual")
    plt.ylabel("Score")
    plt.plot(x,y)
    plt.show()

def chooseParent(Scores,wl):                            #choose parent workloads
    Parental_workloads = []
    indices = biggestNum(Scores)
    #print(indices)
    for iii in indices:
        Parental_workloads.append(wl[iii])
    
    return Parental_workloads                           #return parent workloads

def biggestNum(Scores):                                 #find and locate the workloads with the biggest score
    
    indices = []
    
    cp = Scores.copy()
    
    #1
    max1 = max(cp)
    index = cp.index(max1)
    indices.append(index)
    cp[index] = 0
    
    #2
    max2 = max(cp)
    index = cp.index(max2)
    indices.append(index)

    return indices
    
def crossOver(parents):                                 #crossover of childs as described
    
    next_gen_Workload = []
    
    total_child_pop = N - 2
    #print("total childs ",total_child_pop)
    childs = 0
    while (childs != total_child_pop):
        R = randint(1,L-1)                              #R
        coin = np.random.choice([1,2])                  #C

        lst_child = []
        P_A = parents[0]
        P_B = parents[1]
        if (coin == 1):                                 

            for i in range(R):
                lst_child.append(P_A[i])
            for j in range(R,len(P_B)):
                lst_child.append(P_B[j])
    
        else:
        
            for ii in range(R):
                lst_child.append(P_B[ii])
            for jj in range(R,len(P_A)):
                lst_child.append(P_A[jj])


        next_gen_Workload.append(lst_child)
        childs += 1

    
    next_gen_Workload2 = []                                             #slicing the remaining leaving only inputs
    tL = []
    for i in range(0,total_child_pop):
        for j in range(0,L):
            temporar = next_gen_Workload[i][j][:len(TopInputs)]
            tL.append(temporar)
        next_gen_Workload2.append(tL)
        tL = []
    
    return next_gen_Workload2


def mutation(workload_list):                                #mutation of child's result by propabilities

    
    nums = [0,1]
    for x in range(0,len(workload_list)):
        for y in range(0,L):
            for z in range(0,len(TopInputs)):
                exist = workload_list[x][y][z]
                if exist == 0:
                    sample = np.random.choice(nums,1,p=[1-mut,mut])
                    workload_list[x][y][z] = sample[0]
                else:
                    sample = np.random.choice(nums,1,p=[mut,1-mut])
                    workload_list[x][y][z] = sample[0]
    
    
    return workload_list

def createGraph2(num_generations,score):                    #make graph for 4.2 
    x = np.arange(num_generations)
    y = np.array(score)
    plt.xlabel("generation")
    plt.ylabel("number of switches")
    plt.plot(x,y)
    


def testbench2(ElementTypes,inputs):
    for times in range(3):                      # times of testbench run  
        workloads=[]
        totalSw = []
        best = open("BestScoreGeneration.txt","w")          # file workload with best score 
        totalGenerationHighScores = []
        
        create_signal_len = len(Top)
        for _ in range(0,create_signal_len):
            SignalsTable.append(0)

        newSignalTable = SignalsTable
        #print(newSignalTable)
        for p in range(0,N):                                              # first time random 
            workloads.append(createWorkload(TopInputs,L))
        #print("W before",workloads)
        repeater = 0
        while(repeater != generation):
            p1 = 0
            
            templst = []
            workloadsFULL = []
            for TruthTableInputs in workloads:
                #print(TruthTableInputs)
                score = 0
                loop = 0
                p1+=1
                #print("Workload {}".format(p1))
                for i in TruthTableInputs:
                    #print("================================\n")
                    TotalInputs = TotalInputsGL.copy()
                    TotalOutputs = TotalOutputsGL.copy()
                    for y in range (0, len(newSignalTable)):
                        newSignalTable[y] = 0
                    newSignalTable = table(i)
                    newEltable = crElement(ElementTypes,TotalInputs,TotalOutputs,InputNumElements)
                    
                    # NEW SORTING V2

                    neweltableSorted = []
                    maxi = len(TopInputs)
                    
                    for i1 in newEltable:                           #first t with only top_inputs
                        tongle = 0
                        for x in range(0,len(i1.inputs)):
                            if i1.inputs[x] > maxi:
                                tongle = 1
                        if tongle == 0:    
                            neweltableSorted.append(i1) 
                    for tt in range(len(TopInputs)+1,len(Top)):         #second categorize by priority (do earliest first)
                        for i11 in newEltable:
                            i11.inputs.sort(reverse = True)
                            if (tt == i11.inputs[0]) and (len(i11.inputs) < 4):
                                if i11 not in neweltableSorted:
                                    neweltableSorted.append(i11)

                    for i1 in newEltable:                                        # add the outputs
                        if i1 not in neweltableSorted and len(i11.inputs) > 4:
                            neweltableSorted.append(i1)

                    #for z in neweltableSorted:                                   #sorted elements print
                        
                    #    print("Element Type: ",z.ElementTypes)
                    #    print("Inputs: ",z.inputs, "---> Output: ", z.output)
                        
                    
                    for k in neweltableSorted:                                  #process Sorted table
                        process(k,newSignalTable)
                    if (loop >= 1):                                             #calculate score with more than two workloads
                        score += calcScore(SignalTableBefore,newSignalTable)
                    SignalTableBefore = newSignalTable.copy()                   #remember previous workload with output
                    templst.append(SignalTableBefore) 
                    loop+=1

                totalSw.append(score)
                workloadsFULL.append(templst)
                templst=[]
            
            scoreG = max(totalSw)                                           # Score G = maximum score of workload i       
                             
            

            

            totalGenerationHighScores.append(scoreG)                        

            mean = statistics.mean(totalSw)
            variance = statistics.variance(totalSw)
            print("mean: ",mean)
            print("Variance: ",variance) 
            #makeGraph(N,totalSw)
            #print("FULL",workloadsFULL)
            #print("SW",totalSw)
            
            ParentW = chooseParent(totalSw,workloadsFULL)
            ind = biggestNum(totalSw)
            #print(ind)
            
            Parent1 = ParentW[0]
            Parent2 = ParentW[1]
            print("\n")
            print("Workload {} with score {} :".format(ind[0]+1,totalSw[ind[0]]))
            print(Parent1)
            print("Workload {} with score {} :".format(ind[1]+1,totalSw[ind[1]]))
            print(Parent2)  
            

            cutNewWorkload = crossOver(ParentW)
            #print(cutNewWorkload)
            cutNewWorkload = mutation(cutNewWorkload)
            #print(cutNewWorkload)
            
            workloads = cutNewWorkload.copy()
            cutParents1 = []
            cutParents2 = []
            for x in range(0,L):
                temp_1 = Parent1[x][:len(TopInputs)]
                #print(temp_1)
                cutParents1.append(temp_1)
            for y in range(0,L):
                temp_2 = Parent2[y][:len(TopInputs)]
                cutParents2.append(temp_2)    
            workloads.append(cutParents1)
            workloads.append(cutParents2)
            #print("total workloads",workloads)
            totalSw = []
            repeater += 1
           
        G_sco.append(cutParents1)
        S_score.append(totalGenerationHighScores[len(totalGenerationHighScores)-1])
        print(totalGenerationHighScores)
        createGraph2(generation,totalGenerationHighScores)   #create graph
    
    supe_score =  S_score.index(max(S_score))               #find workload with biggest G SCORE
    #print(supe_score)
    best.write(str(G_sco[supe_score]))
    best.close()
    plt.show()

     



#main
mut = 0.05                  #mutation
N = 30                       #number of workloads
L = 2                       #number of workload's lines
generation = 100              #number of generations

templst = []
G_sco = []
S_score = []

ElementTypes = []       #Gates used
InputNumElements = []   #How many inputs each gate has
SignalsTable = []       #create signal table
TopInputs = []          #Top inputs are stored here
Top = []                #OUR MAIN TABLE with the correct order
TotalInputsGL =[]       #Total inputs used
TotalOutputsGL = []     #Total outputs used

st = time.time()

if (len(sys.argv) > 1):
    UserInput = sys.argv[1]
else:
    print("Syntax Error: .txt file not included!")
    exit(1)


readF(UserInput)
testbench2(ElementTypes,len(TopInputs))

et = time.time()
print("Total execution time %s seconds",et-st) #est 15 seconds

# circuit given by homework
## a b c d e f
## 0 0 0 0 0 1
## 0 0 1 0 0 0
## 0 1 0 0 0 1
## 0 1 1 0 0 0 
## 1 0 0 0 0 1
## 1 0 1 0 0 0
## 1 1 0 1 1 1
## 1 1 1 0 1 0

## switching activity not known workload (3.1 lex)
## Esw = 2*p*(1-p)