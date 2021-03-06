# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils fcaps

DESCRIPTION="Simple C NMDC redirector using threads"
HOMEPAGE="http://klondike.es/programas/nmdcredir/"
SRC_URI="http://klondike.es/programas/${PN}/${P}.tar.gz"
#S="${WORKDIR}/${P}"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

FILECAPS=( -g nmdcredir -m 710 -M 710 cap_net_bind_service usr/bin/${PN} )

RDEPEND="
	acct-group/nmdcredir
	acct-user/nmdcredir
"
DEPEND="${RDEPEND}"
BDEPEND="
	acct-group/nmdcredir
	acct-user/nmdcredir
"

src_install() {
	dobin ${PN}
	fowners root:nmdcredir /usr/bin/${PN}
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
	if use filecaps; then
		ewarn "Using capabilities to allow to listen on ports below 1024"
	fi
}
