import * as React from 'react';
import * as classnames from 'classnames';
import styled from 'styled-components';

import CoreLayout from '../../layouts/CoreLayout';

interface Props {}

export const Home: React.SFC<Props> = (props: any) => {
  return (
    <div className={classnames(props.className, 'home')}>
      <section className="header">
        <h4>Home goes here</h4>
        <p>Talk about something impressive here</p>
      </section>
      <section>
        <h2>Get going, fast</h2>
      </section>
      <section>
        <h2>Another section</h2>
      </section>
    </div>
  );
};

export default styled(CoreLayout(Home))`
section {
  height: 60vh;
  padding: 20px;
  color: ${props => props.theme.dark};
  font-weight: 300;

  h2, h4 {
    text-align: center;
  }
}
section.header {
  color: white;
  background-color: ${props => props.theme.navbarBg};
}
`;
