This currently is set up to build `tor`, `nginx`, and `go`.
`gobuild/build.sh` and `tor-build/build.sh` work out of the
box (the latter provided that the necessary `apt-get install`s
have been done); the nginx part requires manually getting
the openssl tarball from the tor build, and the nginx tarball
from somewhere.

The tor build verifies the checksum of the downloaded openssl tarball.
