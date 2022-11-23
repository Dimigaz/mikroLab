import itertools as it

def sp2AND(input1sp,input2sp):      #handles 2AND
    s = input1sp * input2sp
    return s

def sp2NOT(input1sp):       #handles NOT
    s = 1 - input1sp
    return s

class element:                                      #element type,inputs,outputs
    def __init__(self,ElementTypes,inputs, output):
        self.ElementTypes = ElementTypes
        self.output = output
        self.inputs = inputs
    

def table(inputs):                          #create a truth table
    for i in range(0,len(inputs)):
        SignalsTable[i] = inputs[i]
        
    return SignalsTable

def crElement(ElementTypes,inputs, SignalsTable):
    ElementTable = []
    finalOutput = len(inputs) 
    output = finalOutput +1                 #final output = next from inputs
    inputNum = 0
    for i in ElementTypes:
        if (i == 'AND'):
            if (inputNum == finalOutput):
                inputNum += 1
            tempInputs = []
            tempInputs.append(inputNum)
            inputNum += 1
            tempInputs.append(inputNum)
            inputNum += 1
            if (output == len(SignalsTable)):               #if out put goes out of list= point at final output position
                output = finalOutput
            E = element(i,tempInputs,output)
            output += 1
            if E in ElementTable:
                continue
            else:
                ElementTable.append(E)
        else:
            if (inputNum == finalOutput):
                inputNum += 1
            tempInputs = []
            tempInputs.append(inputNum)
            inputNum += 1
            if (output == len(SignalsTable)):
                output = finalOutput
            E = element(i,tempInputs,output)
            output += 1
            if E in ElementTable:
                continue
            else:
                ElementTable.append(E)
    return ElementTable

def process(element,signalTable):
    if(element.ElementTypes=='AND'):
        signalTable[element.output]=sp2AND(signalTable[element.inputs[0]],signalTable[element.inputs[1]])
    elif(element.ElementTypes=='NOT'):
        signalTable[element.output]=sp2NOT(signalTable[element.inputs[0]])
    else:
        print("Error: Syntax error or unsupported type")

def findEsw(signal):
    s = 2*signal*(1-signal)
    return s


def testbench(ElementTypes,inputs):

    b = [0,1]
    TruthTableInputs = list(it.product(b,repeat = inputs))
    TruthTableInputs.append((0.5,0.5,0.5)) #for esw
    TruthTableInputs.append((0.4035,0.4035,0.4035)) # for personal esw
    for i in ElementTypes:#for signalTable 
        SignalsTable.append(0)
        if (i != 'NOT'):
            SignalsTable.append(0)
    SignalsTable.append(0) #output
    newSignalTable = SignalsTable
    print("++", TruthTableInputs)
    for i in TruthTableInputs:
        
        print("================================")
        for y in range (0, len(newSignalTable)):
            newSignalTable[y] = 0
        newSignalTable = table(i)
        newEltable = crElement(ElementTypes,i,newSignalTable)
        for z in newEltable:
            print("Element Type: ",z.ElementTypes)
            print("Inputs: ",z.inputs, "---> Output: ", z.output,"\n")
        for k in newEltable:
            process(k,newSignalTable)
        print("a    b   c   d   e   f")
        print(newSignalTable,"\n")
        if (i == (0.5,0.5,0.5) or i == (0.4035,0.4035,0.4035)):
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

    




ElementTypes = ['AND','NOT','AND']
SignalsTable = []
testbench(ElementTypes,3)

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