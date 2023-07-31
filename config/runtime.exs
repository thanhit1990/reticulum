import Config
dev_janus_host = "localhost"

config :ret, RetWeb.Plugs.PostgrestProxy,
  hostname: System.get_env("POSTGREST_INTERNAL_HOSTNAME", "localhost")

case config_env() do
  :dev ->
    db_hostname = System.get_env("DB_HOST", "localhost")
    dialog_hostname = System.get_env("DIALOG_HOSTNAME", "dev-janus.reticulum.io")
    hubs_admin_internal_hostname = System.get_env("HUBS_ADMIN_INTERNAL_HOSTNAME", "localhost")
    hubs_client_internal_hostname = System.get_env("HUBS_CLIENT_INTERNAL_HOSTNAME", "localhost")
    spoke_internal_hostname = System.get_env("SPOKE_INTERNAL_HOSTNAME", "localhost")

    dialog_port =
      "DIALOG_PORT"
      |> System.get_env("443")
      |> String.to_integer()

    perms_key =
      "PERMS_KEY"
      |> System.get_env("")
      |> String.replace("\\n", "\n")

    # config :ret, Ret.JanusLoadStatus, default_janus_host: dialog_hostname, janus_port: dialog_port
    config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_dev",
        hostname: db_hostname,
        password: "postgres",
        username: "postgres"
      ]

    config :ret, Ret.PermsToken, perms_key: "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCcBOjWtRiLkTjkB0W6viwlcDVKAcOIyFMWA7CCItwoxE/VitTh\nzdaqbIX/rxnl/NEAbl7menf7eXMey9LHX/tbGj7DpUO4DC5pO4JH+2yu1pUY8GJd\nTtVNOTwOKqnFWeMjAJCRxu5uQZ5Ikw+kAdiouGmAoKYK6WQBcl4nv9cTiQIDAQAB\nAoGAXWdnCdtjNXMcjw93hGQDw+oYTRUfPc1ISJ6u1koOae2VKe+yoPh9MoxD8J2g\nsJqZeVuaPvtEx22fKOm3Z5sjvCh3MbSZz4tUmkJh6DQj8/wagO4huTgsEYNZfMvD\n0C6sD9sAOcpDHuYm9EG7D9HWtNBse8HCNVvGa1ECQgw4lIECQQDLPKKTGgJiLAez\nglXG49HxMqeIRV2kh1DTvD5f6fgNq4t9f8uUERUPoMBNNxNrUnGOXcRRWlCtMc46\nZ/aLq/y5AkEAxIYhisUuaS9BLnPZPbbG6Dnl0wYvjSS7VB4Cvg32c/HqrtpThA9G\naJw9EfjJgRzvDSv11/8w43Q0R4NWBSCFUQJALOqVs5UH+dJpUU74ziADgh8Dz6Yk\n7/vH7UOpNWFsJPlIts/Lmkm8MdwBJA+MBygNWL14adJgCib7wQTBBFVaYQJAVplA\niJTxKZqQH3cfQImdRtHUi1PLeme4QI3k6XjfpCHzJ0+/w46zmP9YDeZSbRmh4W0A\nrUifc2tOakDek+3LsQJBALdZsnxP/mYiWd2ZhZXqxEtOhsT/rFLnZKPgQLQrakY5\n4MNECCyhjJc5E7mdc/mfwc5rxOuCGr1FgmxchWlXEHE=\n-----END RSA PRIVATE KEY-----"

    config :ret, Ret.PageOriginWarmer,
      admin_page_origin: "https://#{hubs_admin_internal_hostname}:8989",
      hubs_page_origin: "https://#{hubs_client_internal_hostname}:8080",
      spoke_page_origin: "https://#{spoke_internal_hostname}:9090"

    config :ret, Ret.Repo, hostname: db_hostname

    config :ret, Ret.SessionLockRepo, hostname: db_hostname

  :test ->
    db_credentials = System.get_env("DB_CREDENTIALS", "admin")
    db_hostname = System.get_env("DB_HOST", "localhost")

    config :ret, Ret.Repo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.SessionLockRepo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_test",
        hostname: db_hostname,
        password: db_credentials,
        username: db_credentials
      ]

  _ ->
    :ok
end
