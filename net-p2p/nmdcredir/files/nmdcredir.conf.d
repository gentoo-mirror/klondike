# /etc/conf.d/adhchpp: config file for /etc/init.d/adchpp

#User under which the server will run
NMDCREDIR_USER="nmdcredir"

#Group under which the server will run
NMDCREDIR_GROUP="nmdcredir"

# Port to listen to
NMDCREDIR_PORT="411"
# Adress to redirect to
NMDCREDIR_ADDR="adcs://localhost:2780/"

#If a message should be sent set this to the hubname
NMDCREDIR_HUBN="TheHub"

#Message to send if NMDCREDIR_HUBN is set
NMDCREDIR_MESS="You are being redirected to our new hub at adcs://localhost:2780/"
