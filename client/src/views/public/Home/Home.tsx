import * as React from 'react'
import * as classnames from 'classnames'

import './Home.scss'
import CoreLayout from '../../../layouts/CoreLayout'
import styled from 'styled-components'

const HomeView = props => (
  <div>
    <div className={classnames("container", "text-center", props.className)}>
      <div className="container text-center">
      <div className="App-title col-xs-6">Exauthly</div>
      <div className="row">
        <div className="col-xs-6">Another testing</div>
      </div>
    </div>
    </div>
  </div>
)

export const Home = CoreLayout(HomeView)

export default Home
