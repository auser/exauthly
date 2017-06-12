import gql from 'graphql-tag';

export default gql`
mutation login($email:Email!,$password:String!) {
  login(email:$email, password: $password) {
    token
    id
    email
  }
}
`;
