{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
  mathcomp-boot,
  deriving,
}:

(mkCoqDerivation {
  pname = "extructures";
  owner = "arthuraa";

  inherit version;
  defaultVersion =
    with lib.versions;
    let
      cmc = c: mc: [
        c
        mc
      ];
    in
    lib.switch [ coq.coq-version mathcomp-boot.version ] (lib.lists.sort (x: y: isLe x.out y.out) (
      lib.mapAttrsToList (out: cases: { inherit cases out; }) {
        "0.5.0" = cmc (range "8.17" "9.0") (range "2.0.0" "2.4.0");
        "0.4.0" = cmc (range "8.17" "8.20") (range "2.0.0" "2.3.0");
        "0.3.1" = cmc (range "8.11" "8.20") (range "1.12.0" "1.19.0");
        "0.3.0" = cmc (range "8.11" "8.14") (isLe "1.12.0");
        "0.2.2" = cmc (range "8.10" "8.12") (isLe "1.12.0");
      }
    )) null;

  releaseRev = v: "v${v}";

  release."0.5.0".sha256 = "sha256-Guu2+tmHym52DA6SB5Rq/rYWIQEl47Q7YvMaUkfOH2k=";
  release."0.4.0".sha256 = "sha256-hItFO2XY2LTPSofPTKt3AfOEfiLliaYdzUXgDv4ea9Y=";
  release."0.3.1".sha256 = "sha256-KcuG/11Yq5ACem4FyVnQqHKvy3tNK7hd0ir2SJzzMN0=";
  release."0.3.0".sha256 = "sha256:14rm0726f1732ldds495qavg26gsn30w6dfdn36xb12g5kzavp38";
  release."0.2.2".sha256 = "sha256:1clzza73gccy6p6l95n6gs0adkqd3h4wgl4qg5l0qm4q140grvm7";

  propagatedBuildInputs = [ mathcomp-boot ];

  meta = with lib; {
    description = "Finite data structures with extensional reasoning";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };

}).overrideAttrs
  (o: {
    propagatedBuildInputs =
      o.propagatedBuildInputs
      ++ lib.optional (lib.versionAtLeast o.version "0.3.0" || o.version == "dev") deriving;
  })
