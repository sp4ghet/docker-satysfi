FROM ocaml/opam:alpine_ocaml-4.06.0

RUN sudo apk add --update\
    m4\
    git\
    unzip\
    wget\
    g++\
    bzip2

RUN  opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git\
    && opam repository add opam-repository https://github.com/ocaml/opam-repository.git\
    && opam update

USER opam
# Permissions errors happen on things that get COPY-ed which is weird but whatever
# https://github.com/moby/moby/issues/6119
COPY --chown=opam:nogroup ./satysfi /home/opam/satysfi
WORKDIR /home/opam/satysfi
RUN opam pin add satysfi .
RUN opam install satysfi

RUN cp -r lib-satysfi /home/opam/.satysfi
COPY ./fonts /home/opam/.satysfi/dist/fonts
COPY ./img/satysfi-logo.jpg ./demo/

CMD ["satysfi"]
