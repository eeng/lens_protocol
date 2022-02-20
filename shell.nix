with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    ruby
  ];
  shellHook = ''
    gem list -i '^bundler$' -v 2.1.4 >/dev/null || gem install bundler --version=2.1.4 --no-document
  '';
}