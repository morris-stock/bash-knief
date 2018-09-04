#!/usr/bin/env bash
#
# import boost library(ies) to be viewed in qtc.
#

usage="usage: `basename $0` <library>"

die()
{
    echo >&2
    echo "$@" >&2
    echo >&2
    exit 1
}

boost_library=$1

[ -n "${boost_library}" ] || die ${usage}
[ -d "libs/${boost_library}" ] || die "No such library: \`${boost_library}'!"

qtc_creator="boost-${boost_library}.creator"
qtc_files="boost-${boost_library}.files"
qtc_config="boost-${boost_library}.config"
qtc_includes="boost-${boost_library}.includes"

# .creator
cat > ${qtc_creator} <<EOF
[General]
EOF

# .files
find libs/${boost_library} -type f -name '*.[hic]pp' > ${qtc_files}

# .config
touch ${qtc_config}

# .includes
cat > ${qtc_includes} <<EOF
.
libs/${boost_library}/include
EOF
