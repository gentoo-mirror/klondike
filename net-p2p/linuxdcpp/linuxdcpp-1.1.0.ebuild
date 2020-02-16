# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Direct connect client, looks and works like famous DC++"
HOMEPAGE="https://launchpad.net/linuxdcpp"
SRC_URI="http://launchpad.net/linuxdcpp/1.1/${PV}/+download/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug +libnotify"

RDEPEND=">=gnome-base/libglade-2.4:2.0
	>=x11-libs/gtk+-2.12:2
	app-arch/bzip2
	dev-libs/boost
	dev-libs/openssl
	libnotify? ( >=x11-libs/libnotify-0.4.1 )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.1
	media-libs/fontconfig
	>=dev-util/scons-0.96
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix_libnotify_always_enabled.patch"
	# prevent scons installation of *txt files to wrong directory
	sed -i 's/.*source = text_files.*//' SConstruct
}

src_compile() {
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[[:space:]]*[0-9]\+\).*/\1/; p }")

	local myconf=""
	use debug && myconf="${myconf} debug=1"
	! use libnotify && myconf="${myconf} libnotify=0"

	scons ${myconf} ${sconsopts} CXXFLAGS="${CXXFLAGS}" PREFIX=/usr || die "scons failed"
}

src_install() {
	# linuxdcpp does not install docs according to gentoos naming scheme, so do it by hand
	dodoc Readme.txt Changelog.txt Credits.txt
	rm "${S}"/*.txt

	scons install PREFIX="/usr" FAKE_ROOT="${D}" || die "scons install failed"

	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} ${PN}
}

pkg_postinst() {
	elog
	elog "After adding first directory to shares you might need to restart linuxdcpp."
	elog
}
