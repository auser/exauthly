import * as React from 'react';
import {marksy} from 'marksy';

import styled from 'styled-components';

const compile = marksy({
  createElement: React.createElement,
  elements: {}
});

export const MarkdownElement = ({className, source, ...rest}) => {
  const compiled = compile(source);
  return (
    <div className={className}>
      {compiled.tree}
    </div>
  );
};

export default styled(MarkdownElement)`
`;
