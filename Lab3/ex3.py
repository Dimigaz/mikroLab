import itertools as it
import sys

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
    s = input1sp*(1-input2sp) + (1-input1sp)*input2sp
    return s

def spXOR(*inputsp):       #handles XOR gates
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

def sp2NOT(input1sp):       #handles NOT gate
    s = 1 - input1sp
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
            for i in range(0,len(tempInp)):                     #add middle outputs (that are also middle inputs)
                Top.append(tempInp[i])
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
    print("HELP",tempInputNumElements)
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
    print(tempInputNumElements)
    

    return ElementTable

def process(element,signalTable):
    if(element.gate == 2):
        if(element.ElementTypes=='AND'):
            signalTable[element.output]=spAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='OR'):
            signalTable[element.output]=spOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='XOR'):
            signalTable[element.output]=spXOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='NAND'):
            signalTable[element.output]=spNAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        elif(element.ElementTypes=='NOR'):
            signalTable[element.output]=spNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
        
    elif(element.gate == 3):
        if(element.ElementTypes=='AND'):
            signalTable[element.output]=spAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='OR'):
            signalTable[element.output]=spOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='XOR'):
            signalTable[element.output]=spXOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='NAND'):
            signalTable[element.output]=spNAND(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])
        elif(element.ElementTypes=='NOR'):
            signalTable[element.output]=spNOR(signalTable[element.inputs[0]],signalTable[element.inputs[1]],signalTable[element.inputs[2]])

    elif(element.ElementTypes=='NOT'):
        signalTable[element.output]=sp2NOT(signalTable[element.inputs[0]])
        #print("NOT")
    
    else:
        print("Error: Syntax error or unsupported type")

def findEsw(signal):
    s = 2*signal*(1-signal)
    return s


def testbench(ElementTypes,inputs):

    b = [0,1]
    N = len(TopInputs)
    TruthTableInputs = list(it.product(b,repeat = inputs))#for truth table
    TruthTableInputs.append((0.5,)*N) #for esw
    TruthTableInputs.append((0.4035,)*N) # for personal esw

    for i in InputNumElements:          #create the signal table
        for ii in range(0,i):
            SignalsTable.append(0)
    SignalsTable.append(0) 
    
    newSignalTable = SignalsTable
    
    for i in TruthTableInputs:
        print("================================\n")
        TotalInputs = TotalInputsGL.copy()
        TotalOutputs = TotalOutputsGL.copy()
        for y in range (0, len(newSignalTable)):
            newSignalTable[y] = 0
        newSignalTable = table(i)
        
        newEltable = crElement(ElementTypes,TotalInputs,TotalOutputs,InputNumElements)
        newEltableSorted = []                        #sorting element table by inputs for better processing
        max = len(TotalInputsGL)
        
        for i1 in range(0,max+1):
            for k9 in newEltable:
                if i1 in k9.inputs:
                    if k9 not in newEltableSorted:
                        newEltableSorted.append(k9)
                    break
                
        
        print("Position of input and output of Gates\n")
        for z in newEltableSorted:                                                  #sorted elements print
            print("Element Type: ",z.ElementTypes)
            print("Inputs: ",z.inputs, "---> Output: ", z.output)
          
        for k in newEltableSorted:
            process(k,newSignalTable)
        print("\n")
        print(Top)
        print(newSignalTable,"\n")
        if (i == (0.5,)*N or i == (0.4035,)*N):
            sa = []
            for zz in newEltable:
                s = findEsw(newSignalTable[zz.output])
                s = round(s,6)
                sa.append(s)
                print("Switching Activity of {} is {} ".format(zz.ElementTypes,s)) 
            sumOfsa = sum(sa)
            numOfsa = len(sa)
            #print("sum: ",sumOfsa)
            #print("len: ",numOfsa)       
            avg = sumOfsa / numOfsa
            avg = round(avg,6)
            print("Average Switching Activity: ",avg)

    



#main

ElementTypes = []       #Gates used
InputNumElements = []   #How many inputs each gate has
SignalsTable = []       #create signal table
TopInputs = []          #Top inputs are stored here
Top = []                #OUR MAIN TABLE with the correct order
TotalInputsGL =[]       #Total inputs used
TotalOutputsGL = []     #Total outputs used


if (len(sys.argv) > 1):
    UserInput = sys.argv[1]
else:
    print("Syntax Error: .txt file not included!")
    exit(1)


readF(UserInput)
testbench(ElementTypes,len(TopInputs))


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