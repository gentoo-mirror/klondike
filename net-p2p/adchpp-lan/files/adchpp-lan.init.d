#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

depend() {
	use dns
	need net
}

PIDFILE=/var/run/${RC_SVCNAME}.pid

start() {
	ebegin "Starting adch++ ${RC_SVCNAME}"
	start-stop-daemon --start --pidfile "${PIDFILE}" -u ${ADCHPP_USER}:${ADCHPP_GROUP} -m -b /usr/bin/adchpp-land -- ${ADCHPP_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping adch++ ${RC_SVCNAME}"
	start-stop-daemon --stop --pidfile "${PIDFILE}" -R SIGINT/5
	eend $?
}
