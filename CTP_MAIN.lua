local socket = require("socket")
local https = require("ssl.https")
local url = require("socket.url")

local ENC = require("IP_ENDEC")


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


if ip then
	print("Public IP Address:", ip)
else
	print("Error:", error_message)
end

local enc_ip = ENC.encode(ip,0)

print(enc_ip)