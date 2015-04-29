# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/opencl/opencl-0-r3.ebuild,v 1.1 2013/06/19 15:45:58 chithanh Exp $

EAPI=5

DESCRIPTION="Soundfont for timidity including instruments and drums"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

DEPEND=""
RDEPEND="app-eselect/eselect-timidity"
PDEPEND="|| (
		media-sound/timidity-eawpatches
		media-sound/timidity-freepats
		media-sound/fluid-soundfont[timidity]
	)"
