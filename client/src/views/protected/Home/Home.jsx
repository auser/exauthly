import React from 'react'
import classnames from 'classnames'

import CoreLayout from 'layouts/CoreLayout/CoreLayout'

console.log(CoreLayout)
import styled from 'styled-components'

const HomeView = props => (
  <div>
    <div className={classnames("container", "text-center", props.className)}>
      <div className="container text-center">
      <div className="App-title col-xs-12">Authly</div>
      <div className="row">
        <div className="col-xs-12 col-sm-4">Another testing</div>
      </div>
    </div>
    </div>
  </div>
)

export const Home = styled(CoreLayout(HomeView))`
`;

export default Home
