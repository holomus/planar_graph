from hikvision import HikEvent

event = HikEvent(host="http://192.168.10.176", login="admin", password="qwertyuiop1234")
result = event.load()

print(str(result[1]).replace("'", "\""))
