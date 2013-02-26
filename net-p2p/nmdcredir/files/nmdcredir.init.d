#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

depend() {
	use dns
	need net
}

PIDFILE=/var/run/${RC_SVCNAME}.pid

# port redirection_address [hub_name redirect_message]
# Port to listen to
NMDCREDIR_PORT="411"
# Adress to redirect to
NMDCREDIR_ADDR="adcs://localhost:2780/"

#If a message should be sent set this to the hubname
NMDCREDIR_HUBN="TheHub"

#Message to send if NMDCREDIR_HUBN is set
NMDCREDIR_MESS="You are being redirected to our new hub at adcs://localhost:2780/"


start() {
	ebegin "Starting nmdcredir ${RC_SVCNAME}"
	if [ -z ${NMDCREDIR_HUBN} ]; then
		start-stop-daemon --start --pidfile "${PIDFILE}" -u ${NMDCREDIR_USER}:${NMDCREDIR_GROUP} -m -b /usr/bin/nmdcredir -- "${NMDCREDIR_PORT}" "${NMDCREDIR_ADDR}"
	else
		start-stop-daemon --start --pidfile "${PIDFILE}" -u ${NMDCREDIR_USER}:${NMDCREDIR_GROUP} -m -b /usr/bin/nmdcredir -- "${NMDCREDIR_PORT}" "${NMDCREDIR_ADDR}" \
																	"${NMDCREDIR_HUBN}" "${NMDCREDIR_MESS}"
	fi
	eend $?
}

stop() {
	ebegin "Stopping nmdcredir ${RC_SVCNAME}"
	start-stop-daemon --stop --pidfile "${PIDFILE}"
	eend $?
}
