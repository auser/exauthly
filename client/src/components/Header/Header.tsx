import * as React from 'react'
import {
  Link
} from 'react-router-dom'

// import AuthMenu from './AuthMenu'
import PublicMenu from './PublicMenu'

import styled from 'styled-components'

export const Header = ({ isAuthenticated, ...rest}) => (
  <header>
    <div className="navbar">
      <div className="container-fluid">
        {/* TODO: Mobile */}
        <div className="navbar-header">
          <div className="navbar-brand">
            <Link to="/">
              Fullstack edu
            </Link>
          </div>
        </div>

        <div className="collapse navbar-collapse">
            {
              isAuthenticated ?
                <AuthMenu {...rest} />
                :
                <PublicMenu {...rest} />
            }
        </div>
      </div>
    </div>
  </header>
)

export default Header
