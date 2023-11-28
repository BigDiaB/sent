local socket = require("socket")
local https = require("ssl.https")
local url = require("socket.url")

local IP_ENDEC = require("IP_ENDEC")


function getPublicIpAddress()
    	local response, status = https.request("https://api.ipify.org/")
    
    	if status == 200 then
        	return response
   	end	
	return nil
end

local port = 8080

local server = assert(socket.bind("*", port))

local ip, error_message = getPublicIpAddress()

print(ip)

local enc_ip = IP_ENDEC.encode(ip,0)
print(enc_ip)

local dec_ip = IP_ENDEC.decode(enc_ip,0)
print(dec_ip)