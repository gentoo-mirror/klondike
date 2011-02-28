# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils qt4-r2 toolchain-funcs

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="ftp://bpmdj.yellowcouch.org/${PN}/${P}.source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa extclock jack midi oss vorbis"

RDEPEND="alsa? ( media-libs/alsa-lib )
	 vorbis? ( media-sound/vorbis-tools )
	 jack? ( media-sound/jack-audio-connection-kit )
	 =sci-libs/fftw-3*"

DEPEND="${RDEPEND}
	|| ( ( x11-libs/qt-core[qt3support] x11-libs/qt-gui[qt3support] )
			>=x11-libs/qt-4.2:4 )
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-4-fix_link_flag_order.patch"
	epatch "${FILESDIR}/${PN}-4-add_GNU_stack_sections.patch"
}

src_configure () {
	# add our defines
	cp "${FILESDIR}/${PN}-4-defines.gentoo" defines || die "Couldn't copy the defines"

	# and now.. the useflags. What a giant PITA!
	local flags=""
	flags="CFLAGS         += -D QT_THREAD_SUPPORT"
	use alsa && flags="${flags} -D COMPILE_ALSA"
	use jack && flags="${flags} -D COMPILE_JACK"
	use oss && flags="${flags} -D COMPILE_OSS"
	use midi && flags="${flags} -D MIDI"
	use extclock && flags="${flags} -D EXT_CLOCK"
	echo "${flags} -D NO_EMPTY_ARRAYS" >> defines

	# and the same for LDFLAGS..
	local lflags=""
	lflags="LDFLAGS        += -lpthread -lm -lrt -lfftw3"
	use alsa && lflags="${lflags} -lasound"
	use jack && lflags="${lflags} -ljack"
	echo "${lflags}" >> defines
	use amd64 && echo "BITS            = 64" >> defines
	use x86 && echo "BITS            = 32" >> defines

	# not to forget our custom C(XX)FLAGS
	echo "CPP             = $(tc-getCXX) -g ${CXXFLAGS} ${CPPFLAGS} -Wall" >> defines
}

src_compile() {
	emake -j1
}

src_install () {
	# makefile is absolutly a mess so we use portage features
	for i in authors changelog copyright readme support; do
		mv ${i}.txt ${i}; dodoc ${i}; done
	dodir /usr/share/${PN}
	#As this is wrapped we change its name
	newbin bpmdj bpmdj_orig
	#Those don't need wrapping so we move them into bin
	dobin bpmcount bpmdj bpmdjraw bpmmerge bpmplay bpmclock
	# needed too..
	mv sequences "${D}/usr/share/${PN}" || die "Couldn't copy sequences"
	# install startup wrapper
	newbin "${FILESDIR}/${PN}-new.sh" bpmdj
	# install logo and desktop entry
	doicon "${PN}-96.png"
	make_desktop_entry ${PN} "BpmDj" ${PN}-96 "AudioVideo;Audio"
}

pkg_postinst() {
	einfo
	einfo "BpmDj looks for its music and index directory under ~/.bpmdj/,"
	einfo "move or link your music directory to ~/.bpmdj/music."
	einfo "If you are upgrading from bpmdj-4.1-r1 or lower you need to"
	einfo "relink the sequences directory. To do so just run this command"
        einfo "as the user who is going to run bpmdj"
	einfo "$ ln -sf /usr/share/bpmdj/sequences ~/.bpmdj"
	einfo
}
