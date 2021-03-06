{ stdenv
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, xmlsec
, cryptography, defusedxml, future, pyopenssl, dateutil, pytz, requests, six
, mock, pyasn1, pymongo, pytest, responses
}:

buildPythonPackage rec {
  pname = "pysaml2";
  version = "4.9.0";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ww1l34zn25vxifs8nr0bg7gkhbpy5g45mj0jj4d8hzimahb1brx";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-xmlsec1-path.patch;
      inherit xmlsec;
    })
  ];

  propagatedBuildInputs = [ cryptography defusedxml future pyopenssl dateutil pytz requests six ];

  checkInputs = [ mock pyasn1 pymongo pytest responses ];

  # Disabled tests try to access the network
  checkPhase = ''
    py.test -k "not test_load_extern_incommon \
            and not test_load_remote_encoding \
            and not test_load_external"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/rohe/pysaml2";
    description = "Python implementation of SAML Version 2 Standard";
    license = licenses.asl20;
  };

}
