# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SCONS_MIN_VERSION=1.2.0

inherit eutils scons-utils toolchain-funcs

DESCRIPTION="ADC protocol hub made by the people behind DC++"
HOMEPAGE="http://adchpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_source.tar.gz"
S="${WORKDIR}/${PN}_${PV}_source"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
#TODOS:
#Add info on script and bloom uses
#Python use only on x86 builds
#Select languages
IUSE="+bloom debug doc +lua pch +python +ruby +script +ssl"

RDEPEND="ssl? ( dev-libs/openssl )
	python? ( || ( dev-lang/python:2.5 dev-lang/python:2.6 dev-lang/python:2.7 ) )
	ruby? ( >=dev-lang/ruby-1.9.2 dev-lang/ruby:1.9 )
	sys-libs/readline"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.40
	>=sys-devel/gcc-4.4
	ruby? ( >=dev-ruby/rubygems-1.8 )
	doc? ( >=app-text/asciidoc-8.6 )"

#This sets some useful variables needed for configure and install
pkg_setup() {
	if use x86; then
		export tarch=x86
	elif use amd64; then
		export tarch=x64
	elif use ia64; then
		export tarch=ia64
	else
		die "Invalid arch"
	fi

	if use debug; then
		export tmode=debug
	else
		export tmode=release
	fi
	#Shortcut for the packages library dir
	export libpath="/usr/$(get_libdir)/${P}"
	export logpath="/var/log/${PN}"
	export etcpath="/etc/${PN}"
	export sharepath="/usr/share/${P}"
	export varpath="/var/lib/${PN}"

	#Create the users
	enewgroup adchpp
	enewuser adchpp -1 -1 -1 "adchpp"
}

src_configure() {
	mylangs=""
	use lua && mylangs=$mylangs,lua
	use python && mylangs=$mylangs,python
	use ruby && mylangs=$mylangs,ruby

	myplugins=""
	use bloom && myplugins=$myplugins,Bloom
	use script && myplugins=$myplugins,Script

	myesconsargs=(
#		CC="$(tc-getCC)"
		plugins=$myplugins
		langs=$mylangs
		mode=$tmode
		$(use_scons ssl)
		$(use_scons pch gch)
		$(use_scons doc docs)
		arch=$tarch
#to use propper ruby
		ruby=ruby19
	)
}

src_prepare() {
	epatch "${FILESDIR}/${P}-allow_set_optional_features.patch"
	epatch "${FILESDIR}/${P}-fix_guide_paths.patch"
	epatch "${FILESDIR}/${P}-fix_doc_includes.patch"
	epatch "${FILESDIR}/${P}-fix_config_paths.patch"
	epatch "${FILESDIR}/${P}-fix_ruby.patch"
	epatch "${FILESDIR}/${P}-fix_python.patch"
	sed -e "s:%%ADCHPPLIB%%:$libpath:g" \
		"${FILESDIR}/adchpp_runner.sh" > adchpp_runner.sh
	sed -e "s:%%ADCHPPLIB%%:$libpath:g" \
	    -e "s:%%ADCHPPSHARE%%:$sharepath:g" \
	    -e "s:%%ADCHPPETC%%:$etcpath:g" \
	    -e "s:%%ADCHPPLOG%%:$logpath:g" \
		-i etc/adchpp.xml -i etc/Script.xml \
		-i rbutil/adchpp.rb -i pyutil/adchpp.py
}

src_compile() {
	escons || die
}

src_install() {
	if use doc; then
		newdoc build/docs/readme.html readme.txt
		dohtml -r build/docs/user_guide/
	fi
	newbin adchpp_runner.sh adchppd
	exeinto "$libpath"
	doexe "build/$tmode-default-$tarch/bin/"adchppd
	doexe "build/$tmode-default-$tarch/bin/"*.so
	keepdir "$logpath"
	fowners root:adchpp  "$logpath"
	fperms 0770 "$logpath"
	insinto "$etcpath"
	doins etc/adchpp.xml
	fowners root:adchpp  "$etcpath"
	fperms 0770 "$etcpath"
	#For some reason the core starts login here before booting
	dosym "$logpath" "$etcpath/logs"
	if use ssl; then
		exeinto "$sharepath"
		doexe linux/generate_certs.sh
		keepdir "$etcpath/certs"
		fperms 0700 "$etcpath/certs"
		fowners adchpp:adchpp  "$etcpath/certs"
		keepdir "$etcpath/certs/trusted"
		fperms 0700 "$etcpath/certs/trusted"
		fowners adchpp:adchpp  "$etcpath/certs/trusted"
	fi
	if use script; then
		insinto "$etcpath"
		doins etc/Script.xml
		insinto "$sharepath/scripts"
		doins plugins/Script/examples/*
		fperms 0750 "$sharepath/scripts"
		fowners root:adchpp  "$sharepath/scripts"
		keepdir "$etcpath/FL_DataBase"
		fowners adchpp:adchpp "$etcpath/FL_DataBase"
		fperms 0770 "$etcpath/FL_DataBase"
		dosym "$etcpath/FL_DataBase" "$sharepath/scripts/FL_DataBase"
	fi
	if use ruby; then
		insinto "$sharepath"
		doins -r rbutil
	fi
	if use python; then
		insinto "$sharepath"
		doins -r pyutil
	fi
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
}
