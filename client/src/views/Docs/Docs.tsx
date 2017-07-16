import * as React from 'react';

import styled from 'styled-components';
import CoreLayout from '../../layouts/CoreLayout';

import Markdown from '../../components/Markdown/Markdown';
import * as RootPage from '../../pages/docs/root.md';

interface Props {}

export const Docs: React.SFC<Props> = (props: any) => {
  const {params} = props.match;
  let page = RootPage;

  return (
    <div className="container">
      <Markdown source={page} />
    </div>
  );
};

export default styled(CoreLayout(Docs))`
`;
