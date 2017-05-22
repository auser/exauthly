import React from 'react'

import {
  Link
} from 'react-router-dom'

import './Landing.css'

import withMainInterface from 'containers/withMainInterface'

const Home = props => (
  <div id="home" className="home">
    <div className="page-top">
      <div className="header">
        <div className="">
        </div>
      </div>
    </div>
    <Link to="/login">Login</Link>
  </div>
)

export default withMainInterface(Home)