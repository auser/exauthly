import gql from 'graphql-tag';

export default gql`
query {
  me {
    id
    email
    name
    token
    gumroadId
  }
}
`
