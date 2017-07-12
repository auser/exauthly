import * as React from 'react';
import * as classnames from 'classnames';
import styled from 'styled-components';

import CoreLayout from '../../layouts/CoreLayout';

interface Props {}

export const Home: React.SFC<Props> = (props: any) => {
  return (
    <div className={classnames(props.className, 'home')}>
      <h2>Home goes here</h2>
    </div>
  );
};

export default styled(CoreLayout(Home))`
`;
