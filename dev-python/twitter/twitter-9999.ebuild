# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1
inherit git-r3

DESCRIPTION="An API and command-line toolset for Twitter (twitter.com)"
HOMEPAGE="https://mike.verdone.ca/twitter/"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/python-twitter-tools/twitter"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
