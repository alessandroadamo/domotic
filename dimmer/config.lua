--- Wifi Parameters ---
WIFI_SSID = "xxxxxx"
WIFI_PWD = "xxxxxx"

-- WiFI IP config (leave blank to use DHCP)
ESP8266_IP = ""
ESP8266_NETMASK = ""
ESP8266_GATEWAY = ""


WIFI_TIMER = 0

STATUS_CHECK_INTERVAL = 5000
STOP_AFTER_ATTEMPTS = 12


--- MQTT Parameters ---
MQTT_BROKER = "192.168.1.200"             -- IP or hostname of MQTT broker
MQTT_PORT = 1883                          -- MQTT port (default 1883)
MQTT_USER = ""                            -- username for authentication if required
MQTT_PWD  = ""                            -- user password if needed for security
MQTT_KEEPALIVE = 5
MQTT_CLIENT_ID = node.chipid()            -- Device ID
MQTT_TOPIC = "home/room1/led1"

--- PWM Ports ---
PIN_ERROR = 0
PWM_MAX_VAL = 255
PWM_CLOCK = 1000
PWM_DUTY = 1023
PWM_PIN = 1
