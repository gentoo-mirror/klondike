#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

depend() {
	use dns
	need net
}

start() {
	ebegin "Starting adch++"
	start-stop-daemon --start --pidfile /var/run/adchppd.pid -u ${ADCHPP_USER}:${ADCHPP_GROUP} -m -b /usr/bin/adchppd ${ADCHPP_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping adch++"
	start-stop-daemon --stop --pidfile /var/run/adchppd.pid -R SIGINT/5
	eend $?
}
