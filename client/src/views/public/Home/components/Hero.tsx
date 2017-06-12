import * as React from 'react'
import * as classnames from 'classnames'
import styled from 'styled-components'

export const Hero = (props:any) => (
  <div className={classnames(props.className)}>
    Things will go here
  </div>
)

export default styled(Hero)`
color: white;
min-height: 150px;
background-color: ${props => props.theme.blue};
text-align: center;
display: flex;
justify-content: center;
align-items: center;
`
