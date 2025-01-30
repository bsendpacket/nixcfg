{
  lib,
  python312Packages,
  fetchPypi,
}:

python312Packages.buildPythonApplication rec {
  pname = "pysqlite3";
  version = "0.5.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+8ab/cDLQ6W63VQDsSbVFRNxtQN+A5e6mAK7RAxbACE=";
  };

  build-system = with python312Packages; [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "pysqlite3"
  ];

  meta = {
    description = "DB-API 2.0 interface for Sqlite 3.x";
    homepage = "https://pypi.org/project/pysqlite3";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pysqlite3";
  };
}
