import * as React from 'react';
// import styled from 'styled-components'

import '../styles/main.scss';
import Header from '../components/header/Header';

interface Props {}

const CoreLayout: React.SFC<Props> = Wrapped => props => {
  return (
    <div>
      <Header {...props} />
      <Wrapped {...props} />
    </div>
  );
};

export default CoreLayout;
