with builtins; with (import <nixpkgs> {}).lib;
{
  ## DO NOT CHANGE THIS
  format = "1.0.0";
  ## unless you made an automated or manual update
  ## to another supported format.

  ## The attribute to build, either from nixpkgs
  ## of from the overlays located in `.nix/coq-overlays`
  attribute = "mathcomp";

  ## If you want to select a different attribute
  ## to serve as a basis for nix-shell edit this
  shell-attribute = "mathcomp-single";

  ## Indicate the relative location of your _CoqProject
  ## If not specified, it defaults to "_CoqProject"
  coqproject = "mathcomp/_CoqProject";

  cachix.coq = {};
  cachix.math-comp.authToken = "CACHIX_AUTH_TOKEN";

  ## select an entry to build in the following `bundles` set
  ## defaults to "default"
  default-bundle = "coq-8.13";

  ## write one `bundles.name` attribute set per
  ## alternative configuration, the can be used to
  ## compute several ci jobs as well

  ## You can override Coq and other Coq coqPackages
  ## through the following attribute

  bundles = let
    master = [
      "mathcomp-finmap" "mathcomp-bigenough" "mathcomp-analysis"
      "mathcomp-abel" "multinomials" "mathcomp-real-closed" "coqeal"
      "fourcolor" "odd-order"
    ];
    common-bundles = listToAttrs (forEach master (p:
       { name = p; value.override.version = "master"; }))
    // { mathcomp-ssreflect.main-job = true; };
  in {
    "coq-8.13".coqPackages = common-bundles // {
      coq.override.version = "8.13";
      paramcoq.override.version = "v1.1.2+coq8.13";
    };
    "coq-8.12".coqPackages = common-bundles // {
      coq.override.version = "8.12";
    };
    "coq-8.11".coqPackages = common-bundles // {
      coq.override.version = "8.11";
    };
  };
}
