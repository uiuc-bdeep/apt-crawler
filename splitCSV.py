import os
import csv
import random

random.seed()
# fileIn: path of file to split
# fileOut1: path of one file to write to
# fileOut2: path of second file to write to
# probability: there will be a (1 in probability) chance that a row will be written to fileOut2
def splitFile(fileIn, fileOut1, fileOut2, probability):
    csvIn = csv.reader(open(fileIn, "r"))
    csvOut1 = csv.writer(open(fileOut1, "a+b"))
    csvOut2 = csv.writer(open(fileOut2, "a+b"))

    firstline = True
    for i in csvIn:
        if firstline:
            csvOut1.writerow(i)
            csvOut2.writerow(i)
            firstline = False
        else:
            rand = random.randint(1, probability)
            if (rand == 1):
                csvOut2.writerow(i)
            else:
                csvOut1.writerow(i)


