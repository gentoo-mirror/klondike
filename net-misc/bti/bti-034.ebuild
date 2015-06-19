# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit bash-completion-r1 eutils

DESCRIPTION="A command line twitter/identi.ca client"
HOMEPAGE="http://gregkh.github.com/bti/"
SRC_URI="mirror://kernel/software/web/bti/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="net-misc/curl
	dev-libs/libxml2
	dev-libs/json-c
	dev-libs/libpcre
	net-libs/liboauth"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

# Readline is dynamically loaded, for whatever reason, and can use
# libedit as an alternative...
RDEPEND="${RDEPEND}
	|| ( sys-libs/readline dev-libs/libedit )"

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "${PN} could not be installed"
	dodoc bti.example README RELEASE-NOTES ||
		die "${PN} documentation could not be installed"
	newbashcomp ${PN}-bashcompletion ${PN} ||
		die "${PN} bashcompletion could not be installed"
}
