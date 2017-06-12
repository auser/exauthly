import gql from 'graphql-tag';

export default gql`
mutation createUser($email:Email!, $password:Password!, $name:String!) {
  signupWithEmailAndPassword(
    email:$email,
    password:$password,
    name:$name
  ) {
    token
  }
}
`
