# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/culmus-ancient/culmus-ancient-0.06.1.ebuild,v 1.3 2010/05/21 04:54:25 ken69267 Exp $

inherit font # versionator

#MY_P=AncientSemiticFonts-$(replace_version_separator 2 '-')

DESCRIPTION="A font that imitates the Daniel Kahn Gillmor's handwriting"
HOMEPAGE="http://lair.fifthhorseman.net/~dkg/fonts/dkg-handwriting/"

#The docs only come with the fontforge version...
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

#if use fontforge; then
#	S=${WORKDIR}/${MY_P}
#	FONT_S=${S}/src
#else
#	S=${WORKDIR}/${MY_P}.TTF
#	FONT_S=${S}/fonts
#fi

src_compile() {
	if use fontforge; then
		./dkg-handwriting.pe || die "Failed to build fonts"
	fi
}
