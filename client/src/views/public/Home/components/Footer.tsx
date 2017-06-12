import * as React from 'react'
import * as classnames from 'classnames'
import styled from 'styled-components'

export const Footer = (props:any) => (
  <div className={classnames(props.className)}>
    Footer
  </div>
)

export default styled(Footer)`
background-color: ${props => props.theme.softGrey};
min-height: 150px;
display: flex;
justify-content: center;
align-items: center;
position: fixed;
bottom: 0;
left: 0;
right: 0;
`
