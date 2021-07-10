# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CABAL_FEATURES="lib profile haddock hscolour"
inherit haskell-cabal

DESCRIPTION="An infinite stream of random data"
HOMEPAGE="http://hackage.haskell.org/package/random-stream"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="urandom openssl"

RDEPEND="dev-haskell/binary
		>=dev-lang/ghc-6.8.2
		openssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

src_prepare() {
	if use urandom; then
		if use openssl; then
			ewarn "This library only supports one random source. Disabling openssl."
		fi
		CABAL_CONFIGURE_FLAGS="--flags=have_urandom"
	elif use openssl; then
		CABAL_CONFIGURE_FLAGS="--flags=have_ssl"
	else
		die "You need one random source."
	fi

}
