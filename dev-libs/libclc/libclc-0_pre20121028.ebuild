# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://people.freedesktop.org/~tstellar/${PN}"
EGIT_COMMIT="40f1a969a35bdba35a0258419ba90400b88de370"

if [[ ${PV} = 9999* || -n "${EGIT_COMMIT}" ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit base $GIT_ECLASS

DESCRIPTION="OpenCL C library"
HOMEPAGE="http://libclc.llvm.org/"

if [[ $PV = 9999* || -n "${EGIT_COMMIT}" ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI=""
fi

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sys-devel/clang-3.1
	>=sys-devel/llvm-3.1"
DEPEND="${RDEPEND}"

PATCHES=(
		"${FILESDIR}/0001-Rename-target-to-r600-amd-none.patch"
		"${FILESDIR}/fix-install-target.patch"
)

src_configure() {
	./configure.py \
		--with-llvm-config="${EPREFIX}/usr/bin/llvm-config" \
		--prefix="${EPREFIX}/usr"
}
