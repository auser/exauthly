## What is [Exauthly](http://github.com/auser/exauthly)

I'm tired of starting new projects and needing to rebuild all the same features over and over for every new project. It's about time that we spend some time building a boilerplate to take care of all these pesky features.

### What are these features?

Said another way, what does this boilerplate give you out of the box?

* Elixir/Phoenix 1.3 application
* Guardian authentication
  * Username/password
  * Social login
* Tested (exauthly was built using test-driven/test-behind development)
* React/Redux/Apollo front-end
* Ultra-fast development speed using [FuseBox](http://fuse-box.org/)
* Protected pages requiring authentication
* GraphQL out of the box with the fantastic [Absinthe](http://absinthe-graphql.org/)
* Logical grouping of users through organizations
* Fine-grained permissions
* and so much more...

### No frills quickstart

```bash
git clone github.com:auser/exauthly.git
cd exauthly && mix deps.get
(cd client && yarn)
iex -S mix phx.server
```

Now, navigate in your browser to the url: [http://localhost:4000](http://localhost:4000). Feel free to play around in the app and come back when you feel comfortable with it. We'll move on to looking deeper at how it runs, how's it's built, and more.
