import * as React from 'react';

import styled from 'styled-components';
import CoreLayout from '../../layouts/CoreLayout';

import Markdown from '../../components/Markdown/Markdown';
import * as AboutPage from '../../pages/about.md';

interface Props {}

export const About: React.SFC<Props> = (props: any) => {
  return (
    <div className="container">
      <Markdown source={AboutPage} />
    </div>
  );
};

export default styled(CoreLayout(About))`
`;
