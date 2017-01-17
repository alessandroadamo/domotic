--- Mqtt section
isMqttReady = false

m = mqtt.Client(MQTT_CLIENT_ID, MQTT_KEEPALIVE, MQTT_USER, MQTT_PWD)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", MQTT_CLIENT_ID .. " offline", 0, 0)

m:on("connect", 
    function(client) 
        print (MQTT_CLIENT_ID .. " connected")
    end)

m:on("offline", 
    function(client)     
        print (MQTT_CLIENT_ID .. " offline")
        m:close()
        isMqttReady = false
    end)

-- on publish message receive event 
m:on("message", 
    function(conn, topic, data) 
        print("Recieved: " .. topic .. ":" .. data)
        if (data ~= nil) then
                    --- check the data validity
                    r = tonumber(data)
                    if (r ~= nil) then
                        if (r < 0) then r = 0 end
                        if (r > PWM_MAX_VAL) then r = PWM_MAX_VAL end
                pwm.setduty(PWM_PIN, r * PWM_DUTY / PWM_MAX_VAL)
                m:publish(MQTT_TOPIC .. "/state", r, 0, 0) 
                print("Status: " .. topic .. "/state:" .. r)
                    else
                        print("Invalid message: " .. data)
                    end
        end
    end)

function mqtt_connected()

    -- for TLS: m:connect("192.168.11.118", secure-port, 1)
    m:connect(MQTT_BROKER, MQTT_PORT, 0,
        function(client) 
            isMqttReady = true
            print("Node connected to " .. 
                MQTT_BROKER .. ":" .. MQTT_PORT .. 
                " as " .. MQTT_CLIENT_ID)
            --- subscribe
            m:subscribe(MQTT_TOPIC, 0, 
                function(conn)
                    print("Subscribing topic: " .. MQTT_TOPIC)
                end)
        end,
        function(client, reason)
            isMqttReady = false
            print("failed reason: " .. reason)
        end)

end
