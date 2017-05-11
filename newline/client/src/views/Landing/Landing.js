import React from 'react'

import {
  Link
} from 'react-router-dom'

import './Landing.css'

export default props => (
  <div id="landing">
    Landing page
    <Link to="/login">Login</Link>
  </div>
)