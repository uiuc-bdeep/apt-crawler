import urllib2
import base64
import datetime
import os
import csv

# url: the url of the csv to grab
# string filePath: the path of the CSV to append to
# username: usename sign in
# password: password sign in
# removeHeader: if True, will remove the first line of url's CSV because its the header
def concat(url, filePath, username="", password="", removeHeader=False):
    request = urllib2.Request(url)
    if(not username=="" and not password==""):
        base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
        request.add_header("Authorization", "Basic %s" % base64string)
    response = urllib2.urlopen(request)

    if(not os.path.exists(filePath)):
        removeHeader=False

    csvIn = csv.reader(response.read().splitlines())
    fileNameTokens = filePath.split('.')
    fileNameTokens[-2] += datetime.datetime.now().strftime("_%H-%M_%d-%m-%y")
    csvFile = csv.writer(open('.'.join(fileNameTokens), "w"))


    firstline = True
    today = datetime.date.today()
    todayStr = "{:%m-%d-%Y}".format(today)
    for i in csvIn:

        if firstline and (not  removeHeader):
            csvFile.writerow(i + ['Date Added'])
            firstline = False
            continue
        if firstline and removeHeader:
            firstline = False
            continue
        csvFile.writerow(i + [todayStr])




url="http://www.placeofmine.com/partners/uiuc/czdfeed.csv"
pathOfCSV="/data/Apartments/stream/rents.csv"
username="uiuc"
password="hfn1923n"
'''
url="http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv"
pathOfCSV=      "/Users/dimyr7/code/python/BDEEP/csvConcat/rents.csv"
username=""
password=""
'''
concat(url, pathOfCSV, username, password, True)

