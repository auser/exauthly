import * as hello from 'hellojs'

const OAuth2Settings = {
  version: 2,
  auth: 'https://api.gumroad.com/oauth/authorize',
  grant: 'https://api.gumroad.com/oauth/token',
  response_type: 'code',
  redirect_uri: 'http://localhost:8080/index.html'
};

hello.init({
  gumroad: {
    name: 'gumroad',
    oauth: OAuth2Settings,
    base: 'https://api.gumroad.com/v2',
  },
  github: process.env.GITHUB_CLIENT_ID
}, {
  oauth_proxy: 'http://localhost:4000/auth/proxy'
})

export default hello
