{ stdenv, fetchurl, buildPythonPackage, pkgconfig, python, enlightenment }:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.22.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${pname}-${version}.tar.xz";
    sha256 = "1qhy63c3fs2bxkx2np5z14hyxbr12ii030crsjnhpbyw3mic0s63";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ enlightenment.efl ];

  propagatedBuildInputs = [ python.pkgs.dbus-python ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl) -I${stdenv.lib.getDev python.pkgs.dbus-python}/include/dbus-1.0 $NIX_CFLAGS_COMPILE"
  '';

  preBuild = "${python.interpreter} setup.py build_ext";

  installPhase= "${python.interpreter} setup.py install --prefix=$out";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for EFL and Elementary";
    homepage = https://phab.enlightenment.org/w/projects/python_bindings_for_efl/;
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
