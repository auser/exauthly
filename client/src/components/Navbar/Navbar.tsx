import * as React from 'react';
import * as classnames from 'classnames';
import {Link} from 'react-router-dom';

import './Header.scss';

import auth from '../../lib/auth';

import styled from 'styled-components';

interface Props {
  isAuthenticated: Function;
  className: string;
  rest: any;
}

export const Navbar: React.SFC<Props> = ({
  isAuthenticated,
  className,
  ...rest
}) =>
  <header className={classnames('navbar', className)}>
    <div className="container">
      <section> </section>
      <section>
        <Link to="/logout">Logout</Link>
      </section>
    </div>
  </header>;

export default styled(Navbar)`
background-color: ${props => props.theme.navbarBg};
height: 80px;
font-size: 1.5em;
color: #fff;
border-radius: 0;
display: flex;
width: 100%;
.container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
section {
  width: 100%;
  &:nth-last-child(1) {
    text-align: right;
  }
}
`;
