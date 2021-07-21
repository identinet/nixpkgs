{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "jx-3";
  version = "3.2.169";

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "09fa5z7id3b44pp7yc8qiyr45cpzzgqqsa1zdv8bxhmg38ygbv17";
  };

  vendorSha256 = "06gm4kqldnm9w484d5c5563m3fdr9arry8jxprhy0x1jjsssbdc9";

  runVend = true;

  doCheck = false;

  subPackages = [ "cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [
    "-ldflags= -X github.com/jenkins-x/jx/pkg/cmd/version.Version=${version}
     -X github.com/jenkins-x/jx/pkg/cmd/version.Revision=${src.rev}
     -X github.com/jenkins-x/jx/pkg/cmd/version.GitTreeState=clean"
  ];

 # postInstall = ''
     # for shell in bash zsh; do
       # $out/bin/cmd completion $shell > cmd.$shell
       # installShellCompletion cmd.$shell
     # done
   # '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/jx
  '';

  meta = with lib; {
    description = "Command line tool for installing and using Jenkins X";
    homepage = "https://jenkins-x.io";
    longDescription = ''
      Jenkins X provides automated CI+CD for Kubernetes with Preview
      Environments on Pull Requests using Jenkins, Knative Build, Prow,
      Skaffold and Helm.
    '';
    license = licenses.asl20 ;
    maintainers = with maintainers; [ edlimerkaj ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
