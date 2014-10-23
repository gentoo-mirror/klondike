# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools savedconfig

DESCRIPTION="JACK audio mixer using GTK2 interface and made in C."
HOMEPAGE="http://69b.org/cms/software/jackmaster"
SRC_URI="http://69b.org/web69/dl/dev_${P}.cpio.7z"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa lash"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.80.0
>=x11-libs/gtk+-2.4.0 x11-libs/gtk+:2
alsa? ( >=media-libs/alsa-lib-0.9.0 )
lash? ( >=media-sound/lash-0.5.0 )
"

DEPEND="${RDEPEND}
app-arch/cpio
app-arch/p7zip
"

src_unpack() {
	unpack ${A}
	cpio -i -I "${WORKDIR}/dev_${P}.cpio"
	chmod 700 "${S}"
}

src_prepare() {
	epatch "${FILESDIR}/fix_configure_in.patch"
	eautoreconf
}

src_configure() {
	restore_config config.h
	econf \
		$(use_enable alsa ) \
		$(use_enable lash )
	mkdir "${S}/src/.deps"
}

src_install() {
	save_config config.h
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
	dobin src/${PN}
	doicon ${PN}16x16.xpm
	make_desktop_entry ${PN} "JackMaster" ${PN}16x16 "AudioVideo;Audio"
}
