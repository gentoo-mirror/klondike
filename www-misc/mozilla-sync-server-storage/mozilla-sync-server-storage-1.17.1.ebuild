# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_{6,7})

inherit distutils-r1 eutils mercurial

DESCRIPTION="Mozilla Sync Storage Server"
HOMEPAGE="https://hg.mozilla.org/services/server-storage/"

EHG_REPO_URI="https://hg.mozilla.org/services/server-storage"

case ${PV} in
9999)
	EHG_REVISION="default"
	;;
*)
	inherit versionator
	MY_PV=$(replace_version_separator 2 '-' "${PV}")
	MY_P="${PN}-${MY_PV}"
	EHG_QUIET="OFF"
	EHG_REVISION="rpm-${MY_PV}"
	S="${WORKDIR}/${PN}"
	;;
esac

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap memcached mysql sqlite test"

#Missing package
RESTRICT="test"

REQUIRED_USE="|| ( ldap memcached mysql sqlite )"

RDEPEND="www-misc/mozilla-sync-server-core[${PYTHON_USEDEP},memcached?,ldap?]
	memcached? ( >=dev-python/pylibmc-1.2.3[${PYTHON_USEDEP}] )
	>=dev-python/simplejson-2.6.2[${PYTHON_USEDEP}]
	>=dev-python/webob-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.10[${PYTHON_USEDEP},mysql?,sqlite?]
	>=dev-python/metlog-py-0.10[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	test? ( >=dev-python/webtest-1.3.3[${PYTHON_USEDEP}] )
	test? ( >=dev-python/wsgiproxy2-0.1[${PYTHON_USEDEP}] )
	test? ( >=dev-python/pylibmc-1.2.3[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
#Not available
#	test? ( dev-python/funkload[${PYTHON_USEDEP}] )

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
