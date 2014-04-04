# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2 cmake-utils eutils user

DESCRIPTION="Lan focused mod of an high performance peer-to-peer hub for the ADC network"
HOMEPAGE="http://uhub.mimic.cz/"
SRC_URI=""
EGIT_REPO_URI="git clone git://github.com/klondi/mimicmod-lan"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +ssl systemd"

#S="${WORKDIR}/uhub"

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.8 )
	!net-p2p/uhub
	!net-p2p/mimicmod"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8.3"

UHUB_USER="${UHUB_USER:-uhub}"
UHUB_GROUP="${UHUB_GROUP:-uhub}"

src_configure() {
	mycmakeargs=(
		$(_use_me_now_inverted "" debug RELEASE)
		$(cmake-utils_use_use ssl)
		$(cmake-utils_use_use systemd)
	)
	cmake-utils_src_configure
}

src_install() {
	dodir /etc/uhub
	cmake-utils_src_install
	doman doc/*1
	dodoc doc/*txt
	insinto /etc/uhub
	doins doc/uhub.conf
	doins doc/users.conf
	fperms 0700 "/etc/uhub"
	fowners ${UHUB_USER}:${UHUB_GROUP} "/etc/uhub"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}

pkg_setup() {
	enewgroup "${UHUB_GROUP}"
	enewuser "${UHUB_USER}" -1 -1 "/var/lib/run/${PN}" "${UHUB_GROUP}"
}
