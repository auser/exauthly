import React from 'react'

import {
  Link
} from 'react-router-dom'

import Header from 'components/Header/Header'

import { css } from 'glamor'


const Home = props => (
  <div id="home" className="home">
    <Header />
    <Link to="/login">Login here</Link>
  </div>
)

export default Home