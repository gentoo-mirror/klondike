# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for nmdcredir"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( nmdcredir )

acct-user_add_deps