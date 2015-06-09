# Maintainer: Jan-Erik Rediger <badboy at archlinux dot us>

pkgname=sync-my-l2p
pkgver=2.1.1
pkgrel=1
pkgdesc="Sync the L2P of the RWTH Aachen with your Computer"
arch=('i686' 'x86_64')
url="http://www.sync-my-l2p.de/"
license=('GPL')
depends=('qt5-base' 'hicolor-icon-theme')
makedepends=('deb2targz')
install=sync-my-l2p.install

if [ "$CARCH" = "x86_64" ]; then
  source=("https://github.com/Sync-my-L2P/Sync-my-L2P/releases/download/v${pkgver}/sync-my-l2p_${pkgver}-0.vivid_amd64.deb")
  noextract=("sync-my-l2p_${pkgver}-0.vivid_amd64.deb")
  md5sums=('dfeb417aeae92072f1ae5547aa5d96e3')
  _short_arch=amd64
else
  source=("https://github.com/Sync-my-L2P/Sync-my-L2P/releases/download/v${pkgver}/sync-my-l2p_${pkgver}-0.vivid_i386.deb")
  noextract=("sync-my-l2p_${pkgver}-0.vivid_i386.deb")
  md5sums=('641830c13298e71e1b370592b64324f8')
  _short_arch=i386
fi

prepare() {
  deb2targz sync-my-l2p_${pkgver}-0.vivid_${_short_arch}.deb
}

package() {
  tar -C $pkgdir -xf sync-my-l2p_${pkgver}-0.vivid_${_short_arch}.tar.xz
}

# vim:set ts=2 sw=2 sts=2 et:
