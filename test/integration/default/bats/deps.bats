

@test "git binary is found in PATH" {
      run which git
      [ "$status" -eq 0 ]
}

@test "apache2ctl is found in PATH" {
    run which apache2ctl
    [ "$status" -eq 0 ]
}
