#!/sbin/openrc-run
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

depend() {
	use dns
	need net
}

PIDFILE=/var/run/${RC_SVCNAME}.pid

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
