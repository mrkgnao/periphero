let 
  rien = import ./.rien/rien.nix {
    packageName = "hello-world";
    packagePath = ./.;

    # Instead of using <nixpkgs>, use a lock-file to stick to
    # a particular `nixpkgs` commit.
    nixpkgsLock = ./nixpkgs.json;

    ghcVersion = "ghc822";

    overrides = rec {
      jailbreak = [ "cabal-helper" "ghc-mod" "liquidhaskell" ];
      skipHaddock = justStaticExecutables;
      skipTests = [ "cabal-helper" "ghc-mod" ];
      justStaticExecutables = [ 
        "brittany" 
        "hpack"
      ];
    };
  };

in
  rien.shell {
    # Generate Hoogle documentation?
    wantHoogle = true;

    # Haskell dependencies
    deps = hsPkgs: with hsPkgs; [
      brittany
      hindent
      hpack
      ghc-mod

      twitter-conduit
      twitter-types
      http-conduit
      stm-conduit

      conduit
      conduit-extra
      conduit-combinators
    ];

    # Optionally, also add sets of related packages that are
    # commonly used together.
    depSets = hsPkgs: with (rien.package-sets hsPkgs); [ ];

    # Native dependencies
    nativeDeps = pkgs: with pkgs; [
      # llvm
    ];
  }
