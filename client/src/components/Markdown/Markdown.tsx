import * as React from 'react';
// import 'highlight.js/styles/github.css';
import * as hljs from 'highlight.js';
import * as hljsJavascript from 'highlight.js/lib/languages/javascript';
import * as hljsBash from 'highlight.js/lib/languages/bash';

import {marksy} from 'marksy';
hljs.registerLanguage('javascript', hljsJavascript);
hljs.registerLanguage('bash', hljsBash);

import styled from 'styled-components';

const compile = marksy({
  createElement: React.createElement,
  highlight(language, code) {
    console.log(language, code);
    return hljs.highlight(language, code).value;
  }
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
