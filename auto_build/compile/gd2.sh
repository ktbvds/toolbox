#!/bin/bash
if ! grep '^GD2$' ${INST_LOG} > /dev/null 2>&1 ;then

## handle source packages
    file_proc ${GD2_SRC}
    get_file
    unpack

## get dependent library dir
    ZLIB_SYMLINK=$(readlink -f /usr/local/zlib)
    ZLIB_DIR=${ZLIB_SYMLINK:-/usr/local/zlib}

    LIBPNG_SYMLINK=$(readlink -f /usr/local/libpng)
    LIBPNG_DIR=${LIBPNG_SYMLINK:-/usr/local/libpng}

    FREETYPE_SYMLINK=$(readlink -f /usr/local/freetype)
    FREETYPE_DIR=${FREETYPE_SYMLINK:-/usr/local/freetype}

    LIBJPEG_SYMLINK=$(readlink -f /usr/local/libjpeg)
    LIBJPEG_DIR=${LIBJPEG_SYMLINK:-/usr/local/libjpeg}

## use ldflags and cppflags for compile and link
    LDFLAGS="-L${ZLIB_DIR}/lib -L${LIBPNG_DIR}/lib -L${FREETYPE_DIR}/lib -L${LIBJPEG_DIR} -Wl,-rpath,${ZLIB_DIR}/lib -Wl,-rpath,${LIBPNG_DIR}/lib -Wl,-rpath,${FREETYPE_DIR}/lib -Wl,-rpath,${LIBJPEG_DIR}/lib"
    CPPFLAGS="-I${ZLIB_DIR}/include -I${LIBPNG_DIR}/include -I${FREETYPE_DIR}/include -I${LIBJPEG_DIR}"

## compile
    CONFIG="./configure \
    --prefix=${INST_DIR}/${SRC_DIR} \
    --disable-static \
    --with-png=${LIBPNG_DIR} \
    --with-freetype=${FREETYPE_DIR} \
    --with-jpeg=${LIBJPEG_DIR}"

    MAKE='make'
    INSTALL='make install'
    SYMLINK='/usr/local/gd2'
    compile

## record installed tag    
    echo 'GD2' >> ${INST_LOG}
fi
