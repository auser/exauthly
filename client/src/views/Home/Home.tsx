import * as React from 'react';
import * as classnames from 'classnames';
import styled from 'styled-components';

import CoreLayout from '../../layouts/CoreLayout';

interface Props {}

export const Home: React.SFC<Props> = (props: any) => {
  return (
    <div className={classnames(props.className, 'home')}>
      <h4>Home goes here</h4>
    </div>
  );
};

export default styled(CoreLayout(Home))`
`;
