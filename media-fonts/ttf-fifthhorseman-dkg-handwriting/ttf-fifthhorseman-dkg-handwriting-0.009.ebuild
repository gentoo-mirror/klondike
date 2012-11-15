# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="A font that imitates Daniel Kahn Gillmor's handwriting"
HOMEPAGE="http://lair.fifthhorseman.net/~dkg/fonts/dkg-handwriting/"

SRC_URI=" fontforge? ( http://dev.gentoo.org/~klondike/${PN}/${P}.tar.lzma )
	!fontforge? ( http://dev.gentoo.org/~klondike/${PN}/${PN}-TTF-${PV}.tar.lzma )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-1+"
IUSE="fontforge"

DEPEND="fontforge? ( media-gfx/fontforge )"
RDEPEND=""

FONT_SUFFIX="ttf"
DOCS="copyright README.TXT"

src_compile() {
	if use fontforge; then
		./dkg-handwriting.pe || die "Failed to build fonts"
	fi
}
