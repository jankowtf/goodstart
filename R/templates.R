#' @importFrom yaml read_yaml
templar__github_actions_workflow_codecov <- function(
  parse = TRUE,
  steps_only = FALSE
) {
  yaml_codecov <- if (!steps_only) {
    "
    steps:
      - uses: actions/checkout@master
      - uses: codecov/codecov-action@v1
        with:
          token: ${{ secrets.CODECOV_TOKEN }} # not required for public repos
          file: ./coverage.xml # optional
          flags: unittests # optional
          name: codecov-umbrella # optional
          fail_ci_if_error: true # optional (default = false)
    "
  } else {
    # "
    #   - uses: actions/checkout@master
    #   - uses: codecov/codecov-action@v1
    #     with:
    #       token: ${{ secrets.CODECOV_TOKEN }} # not required for public repos
    #       file: ./coverage.xml # optional
    #       flags: unittests # optional
    #       name: codecov-umbrella # optional
    #       fail_ci_if_error: true # optional (default = false)"
    "
      - uses: actions/checkout@master
      - uses: codecov/codecov-action@v1
        with:
          token: ${{ secrets.CODECOV_TOKEN }} # not required for public repos"
  }

  if (parse) {
    yaml::read_yaml(text = yaml_codecov)
  } else {
    yaml_codecov
  }
}
