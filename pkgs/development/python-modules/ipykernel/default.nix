{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, argcomplete
, ipython
, jupyter-client
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d82b904fdc2fd8c7b1fbe0fa481c68a11b4cd4c8ef07e6517da1f10cc3114d24";
  };

  # debugpy is optional, see https://github.com/ipython/ipykernel/pull/767
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'debugpy>=1.0.0,<2.0'," ""
  '';

  propagatedBuildInputs = [
    ipython
    jupyter-client
    tornado
    traitlets
  ] ++ lib.optionals (pythonOlder "3.8") [
    argcomplete
  ];

  # check in passthru.tests.pytest to escape infinite recursion with ipyparallel
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
