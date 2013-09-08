# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_{6,7})

inherit distutils-r1 mercurial

DESCRIPTION="Mozilla Sync Server"
HOMEPAGE="https://hg.mozilla.org/services/server-full"

EHG_REPO_URI="https://hg.mozilla.org/services/server-full"

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
IUSE="ldap memcached mysql sqlite test tools +wsgi"

#Missing packages
RESTRICT="test"

REQUIRED_USE="|| ( ldap memcached mysql sqlite )"

RDEPEND="www-misc/mozilla-sync-server-reg[${PYTHON_USEDEP}]
	www-misc/mozilla-sync-server-storage[${PYTHON_USEDEP},ldap?,mysql?,sqlite?]
	tools? ( dev-python/fabric[${PYTHON_USEDEP}] )
	wsgi? (
		|| ( www-apache/mod_wsgi www-servers/uwsgi[python] )
	)
	>=dev-python/mako-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/simplejson-2.6.2[${PYTHON_USEDEP}] )
	test? ( dev-python/twisted-core[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
#Not available
#	test? ( dev-python/funkload[${PYTHON_USEDEP}] )
#	test? ( dev-python/webunit[${PYTHON_USEDEP}] )

src_prepare() {
	sed -i 's_file:%(here)s/etc/_file:%(here)s/_' *.ini
}

src_install() {
	distutils-r1_src_install

	keepdir /etc/mozilla-sync-server
	insinto /etc/mozilla-sync-server
	use ldap && (
		doins etc/ldap.conf
		newins tests_ldap.ini ldap.ini

		use memcached && (
			doins etc/memcachedldap.conf
			newins tests_memcachedldap.ini memcached_ldap.ini
		)
	)
	use memcached && (
		doins etc/memcached.conf
		newins tests_memcached.ini memcached.ini
	)
	use mysql && (
		doins etc/mysql.conf
		newins tests_mysql.ini mysql.ini
	)
	use sqlite && (
		newins etc/sync.conf sqlite.conf
		newins development.ini sqlite.ini
	)
	use wsgi && newins sync.wsgi server.wsgi
}
