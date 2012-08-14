#!/bin/sh
if [ -z "$LD_LIBRARY_PATH" ] ; then
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:%%ADCHPPLIB%%"
else
	export LD_LIBRARY_PATH="%%ADCHPPLIB%%"
fi
exec %%ADCHPPLIB%%/adchppd "$@"
