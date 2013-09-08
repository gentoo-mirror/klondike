# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_{6,7})

inherit distutils-r1 mercurial

DESCRIPTION="Mozilla Sync Server Core libraries"
HOMEPAGE="https://hg.mozilla.org/services/server-core/"

EHG_REPO_URI="https://hg.mozilla.org/services/server-core"

case ${PV} in
9999)
	EHG_REVISION="default"
	;;
*)
	inherit versionator
	MY_PV=$(replace_version_separator 2 '-' "${PV}")
	MY_P="${PN}-${MY_PV}"
	EHG_REVISION="rpm-${MY_PV}"
	S="${WORKDIR}/${PN}"
	;;
esac

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap memcached profile test"

# Test require LDAP populated with mozilla data on ldap://localhost
RESTRICT="test"
#These packages are required but not used
#A single hash means non dependent on other packages required or on the list, double hash implies the contrary
##	>=dev-python/cef-0.5[${PYTHON_USEDEP}]
##	>=dev-python/beaker-1.6.4[${PYTHON_USEDEP}]
##	>=dev-python/docopt-0.5[${PYTHON_USEDEP}]
#	>=dev-python/mako-0.7.2[${PYTHON_USEDEP}]
##	>=dev-python/markupsafe-0.15[${PYTHON_USEDEP}]
##	>=dev-python/pastedeploy-1.5.0
##	>=dev-python/repoze-lru-0.5
#pastescript is required to get the paster command

#These packages are rquired when profile is enabled but I haven't made an ebuild yet
#	profile? ( dev-python/repoze-profiler[${PYTHON_USEDEP}] )
#	profile? ( dev-python/meliae[${PYTHON_USEDEP}] )

RDEPEND="memcached? ( >=dev-python/pylibmc-1.2.3[${PYTHON_USEDEP}] )
	memcached? ( >=dev-python/python-memcached-1.48[${PYTHON_USEDEP}] )
	ldap? ( >=dev-python/python-ldap-2.3.13 )
	>=dev-python/metlog-cef-0.2[${PYTHON_USEDEP}]
	>=dev-python/metlog-py-0.9.8[${PYTHON_USEDEP}]
	>=dev-python/paste-1.7.5.1[${PYTHON_USEDEP}]
	>=dev-python/pastescript-1.7.5[${PYTHON_USEDEP}]
	>=dev-python/recaptcha-client-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/repoze-who-2.0[${PYTHON_USEDEP}]
	>=dev-python/routes-1.13[${PYTHON_USEDEP}]
	>=dev-python/scrypt-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.6.2[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.9
	<=dev-python/sqlalchemy-0.7.999
	>=dev-python/webob-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/wsgiproxy2-0.1[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.4[${PYTHON_USEDEP}]
	>=dev-python/gevent-0.13.8[${PYTHON_USEDEP}]
	>=net-zope/zope-interface-4.0.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/pylibmc-1.2.3[${PYTHON_USEDEP}] )
	test? ( >=dev-python/python-memcached-1.48[${PYTHON_USEDEP}] )
	test? ( dev-python/wsgiintercept[${PYTHON_USEDEP}] )
	test? ( >=dev-python/wsgiproxy2-0.1[${PYTHON_USEDEP}] )
	test? ( dev-python/webtest[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( ${FILESDIR}/${P}_wsgiproxy2.patch )

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
