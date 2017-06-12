import * as React from "react";
import * as classnames from 'classnames'
import { Link } from "react-router-dom";

import './Header.scss';

import AuthMenu from './AuthMenu'
import PublicMenu from "./PublicMenu";

import styled from "styled-components";

// export const Header = ({ isAuthenticated, ...rest}) => (
//   <header>
//     <div className="navbar">
//       <div className="container-fluid">
//         {/* TODO: Mobile */}
//         <div className="navbar-header">
//           <div className="navbar-brand">
//             <Link to="/">
//               Fullstack edu
//             </Link>
//           </div>
//         </div>

//         <div className="collapse navbar-collapse">
//             {
//               isAuthenticated ?
//                 <AuthMenu {...rest} />
//                 :
//                 <PublicMenu {...rest} />
//             }
//         </div>
//       </div>
//     </div>
//   </header>
// )

export const Header = ({ isAuthenticated, className, ...rest }) =>
  <header
    className={classnames("navbar navbar-inverse navbar-static-top affix-top", className)}
    role="banner"
    data-spy="affix"
    data-offset-top="60"
  >
    <div className="container">
      <div className="navbar-header pull-xs-left">
        <button
          className="navbar-toggle collapsed"
          type="button"
          data-toggle="collapse"
          data-target="#navbar"
          aria-controls="navbar"
          aria-expanded="false"
        >
          <span className="sr-only">Toggle navigation</span>
          <span className="icon-bar" />
          <span className="icon-bar" />
          <span className="icon-bar" />
        </button>
        <a href="/" className="navbar-brand">
          Fullstack
        </a>
        <a
          href="/"
          className="logo-text logo-text-inverse visible-xs visible-sm-block visible-md"
          title="Fullstack"
        />
      </div>

      <nav
        id="navbar"
        className="collapse navbar-collapse navbar-collapse-with-panel"
      >
        <a
          className="cover collapsed"
          data-toggle="collapse"
          data-target="#navbar"
          aria-controls="navbar"
          aria-expanded="false"
        />
        <div className="navbar-collapse-panel orderable-xs orderable-sm">
          <div className="navbar-right order-1">
            <ul className="nav navbar-nav">
            {
               isAuthenticated ?
                 <AuthMenu {...rest} />
                 :
                 <PublicMenu {...rest} />
             }
            </ul>
          </div>
        </div>
        <a
          role="button"
          className="navbar-toggle close"
          data-toggle="collapse"
          data-target="#navbar"
          aria-controls="navbar"
          aria-expanded="true"
        >
          ×
        </a>
      </nav>
    </div>
  </header>;

export default styled(Header)`
background-color: ${props => props.theme.blue};
color: #fff;
`;
