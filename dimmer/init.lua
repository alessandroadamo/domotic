dofile ("config.lua")

--- PWM setup ---
pwm.setup(PWM_PIN, PWM_CLOCK, PWM_DUTY);
pwm.start(PWM_PIN);
pwm.setduty(PWM_PIN, 0);

gpio.mode(PIN_ERROR, gpio.OUTPUT)
gpio.write(PIN_ERROR, gpio.HIGH)

--- Global variables
isWifiReady = false
statusCheckCounter = 0
executed = false

--- Connect to the wifi network ---
wifi.sta.sleeptype(wifi.NONE_SLEEP) -- keep the modem on at all time 
wifi.nullmodesleep(false)           -- disable auto sleep in NULL_MODE
wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_SSID, WIFI_PWD) 
wifi.sta.connect()

if ESP8266_IP ~= "" then
    wifi.sta.setip(
        {
            ip = ESP8266_IP, 
            netmask = ESP8266_NETMASK, 
            gateway = ESP8266_GATEWAY
        })
end

--- Mqtt section
dofile("mqtt.lua")

--- Check WiFi connection status ---
function getWiFiStatus()

    ipAddr = wifi.sta.getip()
    if ipAddr == nill then
        if isWifiReady == true then
            isWifiReady = false
            isMqttReady = false
            m:close()
            executed = false
            statusCheckCounter = 0
            gpio.write(PIN_ERROR, gpio.LOW)
        end
    else
        isWifiReady = true
        gpio.write(PIN_ERROR, gpio.HIGH)
    end
    
    if ipAddr ~= nill and isWifiReady == true then 
            
            if executed == false then
                print('Connected with WiFi. IP Add: ' .. ipAddr)
                executed = true
            end

            if isMqttReady == false then
                mqtt_connected()
            end
            
    end
    
end

tmr.alarm(WIFI_TIMER, STATUS_CHECK_INTERVAL, tmr.ALARM_AUTO, 
    
    function()
    
        getWiFiStatus()

        --[[        
        if isWifiReady == true and isMqttReady == true then
            print("WiFi Status: true Mqtt Status: true") 
        elseif isWifiReady == true and isMqttReady == false then
            print("WiFi Status: true Mqtt Status: false") 
        elseif isWifiReady == false and isMqttReady == true then
            print("WiFi Status: false Mqtt Status: true") 
        else
            print("WiFi Status: false Mqtt Status: false") 
        end
        ]]--
        
        -- Stop from getting invifinite loop --
        if isWifiReady == false then
            statusCheckCounter = statusCheckCounter + 1
            print("Status Check Counter: " .. statusCheckCounter)
            gpio.write(PIN_ERROR, gpio.LOW)
        end 
        
        if STOP_AFTER_ATTEMPTS == statusCheckCounter then
            tmr.stop(WIFI_TIMER)
            print("Unable to connect to Wifi. Please check settings...")
            print("Restarting ...")
            node.restart()
        end
    
    end)
        
