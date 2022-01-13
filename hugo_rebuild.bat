:: hugo command does not delete public folder before rebuilding so there could be stale files.  Here we delete the public folder first and then have hugo re-create the static site in the public folder.

@RD /S /Q "public"

hugo


