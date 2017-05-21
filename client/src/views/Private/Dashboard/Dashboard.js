import React from 'react'

import { gql, graphql } from 'react-apollo';

import { connect } from 'react-redux'

export class Dashboard extends React.Component {
  render() {
    const { organizations } = this.props.data;

    return (
      <div>
        <h3>Dashboard</h3>

        {organizations && organizations.map(org => (
          <div key={org.id}>
            <h2>{org.name}</h2>
          </div>
        ))}
      </div>
    )
  }
}

const ORGANIZATION_QUERY = gql`
query CurrentUserOrganizations {
  memberships {
    id
    name
  }
}
`

const withOrganizations = graphql(ORGANIZATION_QUERY)

export default connect(
  state => ({
    products: state.products
  })
)(withOrganizations(Dashboard))