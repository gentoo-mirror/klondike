# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A font that imitates Daniel Kahn Gillmor's handwriting"
HOMEPAGE="http://lair.fifthhorseman.net/~dkg/fonts/dkg-handwriting/"
SRC_URI="https://dev.gentoo.org/~klondike/${PN}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="OFL-1.1"
IUSE="fontforge"

BDEPEND="fontforge? ( media-gfx/fontforge[unicode] )"

FONT_SUFFIX="ttf"
DOCS="CHANGELOG README.TXT"

src_compile() {
	if use fontforge; then
		./dkg-handwriting.pe || die "Failed to build fonts"
	fi
}
