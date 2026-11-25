{
  description = "Citlalpol — the fake outside behind forbidden's door: declared exits only, every attempt recorded";

  inputs = {
    # The same nixpkgs revision as tezcatl's and Xipe Totec's flake.nix on purpose: Xipe Totec runs a
    # target's REPL under Citlalpol, and one pin keeps the three (and a target project that uses the
    # same pin) on the identical Elixir/OTP build. A contract test starts from this fixed environment.
    nixpkgs.url = "github:NixOS/nixpkgs/6201e203d09599479a3b3450ed24fa81537ebc4e";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      beamPackages = pkgs.beam.packages.erlang_27;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          beamPackages.elixir
          beamPackages.erlang
          # test/run.sh: its pong server and JSON, and the client in the wall
          pkgs.python3
          pkgs.curl
        ];

        # forbidden (the wall) is the person's own: on PATH, or CITLALPOL_FORBIDDEN.
        shellHook = ''
          export CITLALPOL_DIR="$PWD"
          export ELIXIR_ERL_OPTIONS="+fnu"
          export PATH="$CITLALPOL_DIR/bin:$PATH"
          echo "Citlalpol dev shell: $(elixir --short-version 2>/dev/null) / OTP $(erl -noshell -eval 'io:put_chars(erlang:system_info(otp_release)), halt().')" >&2
        '';
      };
    };
}
