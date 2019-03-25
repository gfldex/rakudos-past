#! /bin/bash

function qpushd {
	pushd $1 > /dev/null
}

function qpopd {
	popd > /dev/null
}

function build {
	local TO_BUILD_COMMIT="$1"
	cp -aPT --reflink=auto HEAD $TO_BUILD_COMMIT \
	&& qpushd . \
	&& cd $TO_BUILD_COMMIT \
	&& rm -rf ./install/* ./nqp \
	&& git checkout $TO_BUILD_COMMIT \
	&& perl Configure.pl --gen-moar --gen-nqp \
	&& make && make install
	
	DIRT=$(ls -1A .) && DIRT=${DIRT/install/} && xargs -n 1 rm -rf <<<"$DIRT"
	qpopd
}

NROFPASTCOMMITS=$1

git clone https://github.com/rakudo/rakudo HEAD || git -C HEAD pull 2>/dev/null

COMMITS=$(git -C HEAD log --oneline --no-abbrev-commit | cut -d ' ' -f 1 | head -n $NROFPASTCOMMITS)
BUILDS=$(find -maxdepth 1 -name "????????????????????????????????????????" -printf "%f\n")

for LINE in $COMMITS
do
	if [[ ! -d $LINE ]]; then
		echo "building $LINE"
		HERE="$PWD"
		build $LINE
		cd "$HERE"
	fi
	
done
