# /etc/conf.d/adhchpp: config file for /etc/init.d/adchpp

#User under which the server will run
ADCHPP_USER="adchpp"

#Group under which the server will run
ADCHPP_GROUP="adchpp"

#Where to log the stdout messages
ADCHPP_LOG="/etc/adchpp-lan/logs/adchpp-lan"

# see `adchppd -h` for more information
# -c alternative path to the configuration (by default it is /etc/adchpp)
ADCHPP_OPTS="-c /etc/adchpp-lan"
