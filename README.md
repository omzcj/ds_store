# ds_store

> [!IMPORTANT]
> This project is retired. Its `.DS_Store` cleanup and monitoring functionality
> is maintained in
> [miniTools](https://github.com/oh-my-brew/miniTools). Existing releases remain
> available for historical and recovery purposes, but no further releases are
> planned.

## Release

Update `VERSION` and push the change to `main`. The release workflow validates
the executable and publishes `ds_store-VERSION.tar.gz` to a GitHub Release
tagged `vVERSION` in `oh-my-brew/ds_store`, using the shared
`oh-my-infra/brew-ci` workflow.

Manual workflow runs default to `publish: false`: validate the existing version,
run the project validation, and compare two source archives without changing
`VERSION` or creating a tag or release. Select `publish: true` explicitly to
publish. Source pushes to `main` retain their existing automatic release behavior.
