import * as React from 'react'
import {
  Link
} from 'react-router-dom'

export const PublicMenu = props => (
  <ul className="nav navbar-nav navbar-right">
    <li>
      <Link to="/login">Login</Link>
    </li>
  </ul>
)

export default PublicMenu
