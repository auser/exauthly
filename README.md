# Authly

This is a Phoenix 1.3 application with accounts, organizations, and more. This is intended on being used as a starting point for production applications with authentication, groups, and payments.

All the business logic of Exauthly exists in phoenix contexts.

Accounts is the first (and currently only context).

The graphql and web contexts are consumers of the functionality.

## Features

* Authentication
  * Email/password
  * Social login
    [] Gumroad
    [] Github
    [] Twitter
  [] Organizations
  [] Billing
  [] Membership
    [] Invitations

## Quickstart

```bash
mix deps.get
mix ecto.setup
(cd assets && npm install)
mix phx.server
```

## Tests

Exauthly is intended on being 100% tested and written using TDD or TBD. To execute the tests, run:

```bash
MIX_ENV=test mix deps.get
mix tests
```

