import gql from 'graphql-tag';

export default gql`
mutation socialLogin($social_account_id:String!, $social_account_name:String!) {
  socialLogin(socialAccountId: $social_account_id, socialAccountName:$social_account_name) {
    token
    id
    email
  }
}
`;
