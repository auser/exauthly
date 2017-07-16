import * as React from 'react';
import * as classnames from 'classnames';
import styled from 'styled-components';

import CoreLayout from '../../layouts/CoreLayout';

interface Props {}

export const Home: React.SFC<Props> = (props: any) => {
  return (
    <div className={classnames(props.className, 'home')}>
      <div className="jumbotron">
        <h4>Home goes here</h4>
      </div>
    </div>
  );
};

export default styled(CoreLayout(Home))`
.jumbotron {
  height: 60vh;
  text-align: center;
  background-color: ${props => props.theme.navbarBg};
  color: white;
  font-weight: 300;
}
`;
