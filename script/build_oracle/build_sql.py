import chardet
import os
import codecs
success = 1
DIRECTORY = ""
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
        f = open(DIRECTORY + "/" + filePath, mode='rb')
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
        f = open(DIRECTORY + "/" + filePath, mode="rb").read()        
        enc = chardet.detect(f)['encoding']
        enc = checkEncoding(enc, filePath)
        return "\n".join(filter(lambda x: x[0:6] != "prompt", f.decode(enc, 'replace').replace("\r","").split('\n')))
    except IOError:
        print('{0} file not found'.format(filePath))
        global success
        success = 0
        return ''
def readBufferFrom(filePath, exceptPath, data):
    result = ""
    for line in readLinesFrom(filePath):        
        if line[0:2] == "@@":
            path = line[2: len(line)].replace(";","")
            if path == exceptPath[0]:
                result += data[0]
            elif path == exceptPath[1]:
                result += data[1]
            else:
                result += readFrom(path)
        else:
            result += line
        result += "\n"
    return result

def writeFileByEncode(path, data, encode):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    c = codecs.open(path, mode="wb")    
    c.write(data.encode(encode))
    c.close()

def deleteFile(path):
    try:
        os.remove(path)
        print(f"file {path} deleted.")
    except FileNotFoundError:
        print(f"file {path} does not exist.")
    
cwd = os.getcwd()
dirs   = cwd.replace('\\','/').split('/')
file_prefix = dirs[len(dirs) - 3]
directory_path = '/'.join(dirs[0: len(dirs) - 2])
file_path = directory_path + '/release/install_db/{}'.format(file_prefix)
DIRECTORY = directory_path + '/main/oracle'

startUi = readBufferFrom('start_ui.sql', ['', ''], '')
startUis = readBufferFrom('start_uis.sql', ['', ''], '')
start   = readBufferFrom('start.sql', ['start_ui.sql', 'start_uis.sql'], [startUi, startUis])
startAll= readBufferFrom('start_all.sql', ['start.sql', ''], [start])

if success == 1:
    print("read files successful ...")
    deleteFile(file_path + "_pack.sql")
    deleteFile(file_path + "_all.sql")
    writeFileByEncode(file_path + "_pack.sql", start, "utf-8")       
    writeFileByEncode(file_path + "_all.sql", startAll, "utf-8")
    print("create " + file_prefix + "_pack.sql successful...")
    print("create " + file_prefix + "_all.sql successful...")        
else:
    print("fail ...")        
