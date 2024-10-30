FROM ocaml/opam2:alpine as build

# Install system dependencies
RUN sudo apk add --update \
    make libffi-dev linux-headers m4 ncurses-dev perl pkgconf postgresql-dev \
    musl-dev git pkgconfig gmp-dev libc-dev openblas-dev zlib-dev \
    npm nodejs

RUN eval $(opam env) && opam repository set-url default https://opam.ocaml.org && opam update

WORKDIR /build
RUN sudo chown -R $(whoami) /build

# Install dependencies
ADD sapiens.opam sapiens.opam
RUN opam pin add -y --no-action rock.~dev https://github.com/rgrinberg/opium.git
RUN opam pin add -y --no-action opium.~dev https://github.com/rgrinberg/opium.git
RUN opam pin add -y --no-action opium-testing.~dev https://github.com/rgrinberg/opium.git
RUN opam pin add -y --no-action lwd.~dev https://github.com/let-def/lwd.git
RUN opam pin add -y --no-action tyxml-lwd.~dev https://github.com/let-def/lwd.git#tyxml-scheduler
RUN eval $(opam env) && opam install . --deps-only

# Build project
ADD asset/ asset/
ADD bin/ bin/
ADD config/ config/
ADD lib/ lib/
ADD dune dune-project package.json package-lock.json Makefile ./

RUN sudo chown -R $(whoami) .

RUN eval $(opam env) && npm install
RUN eval $(opam env) && make release

FROM alpine:3.12 as docker

RUN apk add --update gmp libpq

COPY --from=build /build/_build/default/bin/server.exe /bin/server

ENV SAPIENS_ENV prod
ENV SAPIENS_MAILGUN_API_KEY fc4d53ab333a3bd2b349379c874f5a57-913a5827-b87970e2
ENV SAPIENS_SECRET_KEY 6qWiqeLJqZC/UrpcTLIcWOS/35SrCPzWskO/bDkIXBGH9fCXrDphsBj4afqigTKe

CMD /bin/server --port=$PORT
