import chardet
import os
import codecs
import sys
success = 1
CURRENT_DIRECTORY = ""
def checkEncoding(encode, path):
    enc = encode.lower()
    if not(enc == "ascii" or
           enc == "utf-8" or
           enc == "windows-1251"):
        print('changed this file {0} encode {1} to windows-1251 please check making file'.format(path, encode))
        encode = 'windows-1251'
    return encode
def readLinesFrom(filePath):
    try:        
        f = open(CURRENT_DIRECTORY + "/" + filePath, mode='rb')
        enc = chardet.detect(f.read())['encoding']        
        enc = checkEncoding(enc, filePath)        
        f.seek(0)
        lines = f.readlines()
        tabs = []        
        for line in lines:
            line = line.decode(enc, 'replace').strip().replace("\\","/")
            if line[0:6] == "prompt":
                continue
            tabs.append(line)
        return tabs
    except IOError:
        print('{0} file not found'.format(filePath))
        global success
        success = 0
        return []

def readFrom(filePath):
    try:        
        f = open(READ_DIRECTORY + "/" + filePath, mode="rb").read()        
        enc = chardet.detect(f)['encoding']
        enc = checkEncoding(enc, filePath)
        return "\n".join(filter(lambda x: x[0:6] != "prompt", f.decode(enc, 'replace').replace("\r","").split('\n')))
    except IOError:
        print('{0} file not found'.format(filePath))
        global success
        success = 0
        return ''
def readBufferFrom(filePath):
    result = "set define off\n"
    for line in readLinesFrom(filePath):        
        result += readFrom(line)
        result += "\n"
    return result

def writeFileByEncode(path, data, encode):    
    c = codecs.open(path, mode="wb")    
    c.write(data.encode(encode))
    c.close()
    
cwd = os.getcwd()
dirs   = cwd.replace('\\','/').split('/')
prefix = sys.argv[2] if len(sys.argv) > 2 else sys.argv[1] if len(sys.argv) > 1 else dirs[len(dirs) - 3]
CURRENT_DIRECTORY = '/'.join(dirs)
READ_DIRECTORY = CURRENT_DIRECTORY + '/../..'

difference = readBufferFrom('difference.txt')

if success == 1:
    print("read files successful ...")
    try:
        writeFileByEncode(prefix + " (pck).sql", difference, "utf-8")
        print("Create " + prefix + " (pck).sql successful...")         
    except IOError:
        print("fail ... to create " + prefix + " (pck).sql")
else:
    print("fail ...")
